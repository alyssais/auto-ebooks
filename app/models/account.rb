class Account < ActiveRecord::Base
  validates_presence_of :uid, :username, :token, :secret

  def client
    Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.consumer_key
      config.consumer_secret = Rails.application.secrets.consumer_secret
      config.access_token = token
      config.access_token_secret = secret
    end
  end
end
