class Bot < Ebooks::Bot
  def initialize(account)
    @account = account

    super(account.username) do |bot|
      bot.consumer_key = Rails.application.secrets.consumer_key
      bot.consumer_secret = Rails.application.secrets.consumer_secret
      bot.oauth_token = account.token
      bot.oauth_token_secret = account.secret

      bot.on_message do |dm|
        if should_reply? dm
          bot.reply(account.model.make_response(dm[:text], 160))
        end
      end

      bot.on_follow do |user|
        bot.follow(user[:screen_name])
      end

      bot.on_mention do |tweet, meta|
        if should_reply? tweet
          reply(tweet, meta)
        end
      end

      bot.on_timeline do |tweet, meta|
        if should_reply? tweet
          multiplier = tweet[:user][:id_str] == based_on
          tokens = Ebooks::NLP.tokenize(tweet[:text])
          tokens.map! { |t| t.downcase.gsub(/[^\w]/, "") }

          reply_threshold = 10 * multiplier
          fav_threshold = 100 * multiplier

          keywords = model.keywords.top(fav_threshold).map { |t| t.to_s.downcase }

          if (keywords.first(reply_threshold) & tokens).count > 0
            reply(tweet, meta)
          elsif (keywords & tokens).count > 0
            bot.twitter.favorite(tweet[:id])
          end
        end
      end

      bot.scheduler.every '1h' do
        bot.tweet(account.model.make_statement)
      end

      def reply(tweet, meta)
        reply_to = meta[:reply_prefix].gsub(/@/, "").split(/\s/)
        reply_to.select! do |username|
          @client.friendship(username, account.username)[:relationship][:source][:followed_by]
        end
        reply_prefix = reply_to.map { |u| "@#{u}" }.join(" ") + " "
        length = 140 - reply_prefix
        response = account.model.make_response(tweet[:text], length)
        bot.reply(tweet, response)
      end

      def should_reply?(tweet_or_dm)
        user = tweet_or_dm[:sender] || tweet_or_dm[:user]
        should_reply = true
        should_reply &= !user[:screen_name].end_with?("_ebooks")
        should_reply &= !tweet_or_dm[:retweeted]
      end
    end
  end
end
