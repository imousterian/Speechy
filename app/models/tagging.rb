class Tagging < ActiveRecord::Base
  belongs_to :tag, dependent: :destroy
  belongs_to :content
  has_many :student_responses
end
