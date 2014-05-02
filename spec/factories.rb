FactoryGirl.define do
  factory :account do
    sequence(:uid)
    name "Test Account"
    sequence(:username) { |n| "test_account#{n}" }
    token { SecureRandom.hex }
    secret { SecureRandom.hex }
    based_on "PenmanRoss"

    factory :valid_account do
      %w[uid username token secret].each do |field|
        send(field, Rails.application.secrets.test_account.send(:[], field))
      end
    end
  end
end
