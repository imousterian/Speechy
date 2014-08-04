class StudentResponse < ActiveRecord::Base
    belongs_to :student
    belongs_to :tagging
    has_one :tag, through: :tagging
    has_one :content, through: :tagging

    validates :student_id, presence: true

    # StudentResponse.join(taggings: :tag).where('recorded_emotion != tag.tagged_emotion')
end
# has_many :student_responses, through: :taggings
