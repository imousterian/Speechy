require 'rails_helper'

RSpec.describe User, :type => :model do

    let(:user) {FactoryGirl.create(:user)}

    subject {user}

    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }

    it { should be_valid }

    it "is invalid without an email" do
        user1 = build(:user, email: nil)
        user1.valid?
        expect(user1.errors[:email]).to include("can't be blank")
    end

    it "is invalid with a duplicate email address" do
        FactoryGirl.create(:user, email: "fidel@awesome.com")
        user1 = build(:user, email: "fidel@awesome.com")
        user1.valid?
        expect(user1.errors[:email]).to include("has already been taken")
    end

    describe "guest user" do
        guest_user = User.new(:guest => true)
        it "should be marked as a guest" do
            expect(guest_user.guest?).to be_truthy
        end
    end

    describe "admin user" do
        admin_user = User.new(:admin => true)
        it "should be marked as a admin" do
            expect(admin_user.admin?).to be_truthy
        end
    end

    describe "when email address is already taken" do
        it "is not valid" do
            user_with_same_email = build(:user)
            user_with_same_email.email = user.email
            user_with_same_email.valid?
            expect(user_with_same_email.errors[:email]).to include("has already been taken")
        end
    end
end
