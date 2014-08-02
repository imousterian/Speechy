require 'rails_helper'

RSpec.describe User, :type => :model do

    let(:user) {FactoryGirl.create(:user)}

    it { should respond_to(:email) }
    it { should respond_to(:password)}
    it { should respond_to(:password_confirmation)}

    # it {should be_valid}


    describe "when email address is already taken" do
        before do
            user_with_same_email = user.dup
            user_with_same_email.email = user.email.upcase
            user_with_same_email.save
        end

        it {should_not be_valid}
    end

end
