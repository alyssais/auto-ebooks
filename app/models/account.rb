class Account < ActiveRecord::Base
  validates_presence_of :uid, :username, :token, :secret

  def client
    @client ||= Twitter::Client.new(
      consumer_key: Rails.application.secrets.consumer_key,
      consumer_secret: Rails.application.secrets.consumer_secret,
      oauth_token: token,
      oauth_token_secret: secret
    )
  end

  def update_model
    Ebooks::Archive.new(based_on, archive_path, client).sync
    model = Ebooks::Model.consume(archive_path)
    binding.pry
    update model_dump: Marshal.dump(model)
  end

  def model
    Marshal.load(model_dump)
  end

  def bot
    Bot.get(username) || Bot.new(self)
  end

  private

  def delete_archive
    File.delete(archive_path) if File.exist?(archive_path)
  end

  def archive_path
    "#{Rails.root}/corpus/#{based_on}.json"
  end
end
