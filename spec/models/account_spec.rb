require 'spec_helper'

describe Account do
  it { should validate_presence_of :uid }
  it { should validate_presence_of :username }
  it { should validate_presence_of :token }
  it { should validate_presence_of :secret }

  it "can post a tweet" do
    account = FactoryGirl.create(:valid_account)
    content = SecureRandom.uuid
    account.client.update(content)
    account.client.user_timeline.first[:text].should == content
  end
end
