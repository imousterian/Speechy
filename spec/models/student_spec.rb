require 'rails_helper'

RSpec.describe Student, :type => :model do

    let(:student) {FactoryGirl.create(:student)}
    # let(:student_response) {FactoryGirl.create(:student_response)}

    it "is valid when a name is present" do
        expect(student).to be_valid
    end

    it "is invalid without a name" do
        student = Student.new(name: nil)
        student.valid?
        expect(student.errors[:name]).to match_array (["can't be blank"])
    end

    it "correctly returns a percentage of answers" do
        student = Student.create(name: 'Student')
        student.student_responses.build(:emotion => 'sad', :created_at => 1.week.ago, :correct => true)
        student.student_responses.build(:emotion => 'happy', :created_at => 2.weeks.ago, :correct => false)
        student.save!

        expect(student.percentages).to eq [
            {:unit=>Date.parse(2.weeks.ago.to_s), :status=>"Correct", :val=>0},
            {:unit=>Date.parse(2.weeks.ago.to_s), :status=>"Not correct", :val=>100},
            {:unit=>Date.parse(1.week.ago.to_s), :status=>"Correct", :val=>100},
            {:unit=>Date.parse(1.week.ago.to_s), :status=>"Not correct", :val=>0}]
    end

    it "correctly converts response data to csv"
    it "correctly returns a percentage of answers"
end
