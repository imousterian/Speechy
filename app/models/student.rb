class Student < ActiveRecord::Base
    belongs_to :user
    has_many :student_responses

    validates :name, :presence => true, :uniqueness => true
end
