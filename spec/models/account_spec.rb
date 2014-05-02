require 'spec_helper'

describe Account do
  it { should validate_presence_of :uid }
  it { should validate_presence_of :username }
  it { should validate_presence_of :token }
  it { should validate_presence_of :secret }

  before do
    @account = FactoryGirl.create(:valid_account)
  end

  it "can tweet" do
    content = SecureRandom.uuid
    @account.client.update(content)
    @account.client.user_timeline.first[:text].should == content
  end

  it "can create its model" do
    @account.send(:delete_archive)
    @account.update model_dump: nil
    @account.update_model
    @account.model.should_not be_nil
  end

  describe "#bot" do
    it "returns an instance of Ebooks::Bot" do
      @account.bot.should be_kind_of Ebooks::Bot
    end
  end
end
