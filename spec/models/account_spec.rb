require 'spec_helper'

describe Account do
  it { should validate_presence_of :uid }
  it { should validate_presence_of :username }
  it { should validate_presence_of :token }
  it { should validate_presence_of :secret }
end
