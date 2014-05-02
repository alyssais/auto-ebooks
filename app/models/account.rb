class Account < ActiveRecord::Base
  validates_presence_of :uid, :username, :token, :secret
end
