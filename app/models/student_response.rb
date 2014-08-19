class StudentResponse < ActiveRecord::Base
    belongs_to :student
    belongs_to :tagging
    has_one :tag, through: :tagging
    has_one :content, through: :tagging

    validates :student_id, presence: true

    # StudentResponse.join(taggings: :tag).where('recorded_emotion != tag.tagged_emotion')
    def response_correct?
        new_list = []
        taglist.split(",").map do |n|
            new_list <<  Tag.joins(:taggings).where(taggings: {id: n.strip}).map(&:tagname).join(", ")
        end
        # print new_list
        # new_list
        return new_list.include?(emotion)
    end

end

# has_many :student_responses, through: :taggings
