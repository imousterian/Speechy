class Tagging < ActiveRecord::Base
  belongs_to :tag, dependent: :delete
  belongs_to :content
  has_many :student_responses
end
