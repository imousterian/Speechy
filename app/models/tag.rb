class Tag < ActiveRecord::Base
    has_many :taggings
    has_many :contents, through: :taggings
    has_many :student_responses, through: :taggings
    belongs_to :user
end
