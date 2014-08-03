class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :content
  has_many :student_responses
end
