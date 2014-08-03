class StudentResponse < ActiveRecord::Base
    belongs_to :student
    belongs_to :tagging
    belongs_to :tag, through: :tagging
    belongs_to :content, through: :tagging
end
