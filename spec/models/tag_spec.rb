require 'rails_helper'

RSpec.describe Tag, :type => :model do
    let(:tag){FactoryGirl.create(:tag)}
    subject{tag}
    it {should be_valid}
    it {should belong_to :user}

    describe "without content" do
        before {tag.tagname = nil}
        it {should_not be_valid}
    end
end
