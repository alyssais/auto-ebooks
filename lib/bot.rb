class Bot < Ebooks::Bot
  attr :running

  def initialize(account)
    @account = account

    super(account.username) do |bot|
      bot.consumer_key = Rails.application.secrets.consumer_key
      bot.consumer_secret = Rails.application.secrets.consumer_secret
      bot.oauth_token = account.token
      bot.oauth_token_secret = account.secret

      bot.on_message do |dm|
        if should_reply? dm
          bot.reply(dm, account.model.make_response(dm[:text], 160))
        end
      end

      bot.on_follow do |user|
				unless user[:id_str] == account.uid
					bot.follow(user[:screen_name])
				end
      end

      bot.on_mention do |tweet, meta|
        if should_reply? tweet
          auto_reply(tweet, meta)
        end
      end

      bot.on_timeline do |tweet, meta|
        if should_reply? tweet
          multiplier = tweet[:user][:id_str] == account.based_on ? 2 : 1
          tokens = Ebooks::NLP.tokenize(tweet[:text])
          tokens.map! { |t| t.downcase.gsub(/[^\w]/, "") }

          reply_threshold = 10 * multiplier
          fav_threshold = 100 * multiplier

          keywords = account.model.keywords.top(fav_threshold).map { |t| t.to_s.downcase }

          if (keywords.first(reply_threshold) & tokens).count > 0
            auto_reply(tweet, meta)
          elsif (keywords & tokens).count > 0
            bot.twitter.favorite(tweet[:id])
          end
        end
      end

      bot.scheduler.every '1h' do
        bot.tweet(account.model.make_statement)
      end

   end
  end

  def auto_reply(tweet, meta)
    reply_to = meta[:reply_prefix].gsub(/@/, "").split(/\s/)
    reply_to.select! do |username|
      tweet[:user][:screen_name] == username || check_followed_by(username) 
    end
    reply_prefix = reply_to.map { |u| "@#{u}" }.join(" ") + " "
    length = 140 - reply_prefix.length
    response = @account.model.make_response(tweet[:text], length)
    reply(tweet, reply_prefix + response)
  end

	def check_followed_by(username_or_id)
		friendship = @account.client.friendship(username_or_id, @account.username)
		followed_by = friendship[:source][:followed_by]
		@account.client.unfollow(username) unless followed_by
		followed_by
  end

  def should_reply?(tweet_or_dm)
    user = tweet_or_dm[:sender] || tweet_or_dm[:user]
    should_reply = true
    should_reply &= !user[:screen_name].end_with?("_ebooks")
    should_reply &= !tweet_or_dm[:retweeted]
  end

  def start
    @running = true
    super
  end
end
