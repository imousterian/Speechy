require 'rails_helper'

RSpec.describe Student, :type => :model do

    let(:student) {FactoryGirl.create(:student)}
    let(:student_response) {FactoryGirl.create(:student_response)}

    it "is valid when a name is present" do
        expect(student).to be_valid
    end

    it "is invalid without a name" do
        student = Student.new(name: nil)
        student.valid?
        expect(student.errors[:name]).to match_array (["can't be blank"])
    end
    it "correctly returns a percentage of answers"
    it "correctly returns responses sorted by asc date"
    it "correctly converts response data to csv"
end
