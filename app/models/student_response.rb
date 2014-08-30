class StudentResponse < ActiveRecord::Base
    belongs_to :student
    belongs_to :tagging
    has_one :tag, through: :tagging
    has_one :content, through: :tagging

    validates :student_id, presence: true
    validates :emotion, presence: true
    validate :only_letters

    scope :sorted_date,   ->   { order('created_at DESC') }

    before_save :set_downcase

    def tagging_responses
        new_list = []
        taglist.split(",").map do |n|
            # new_list <<  Tag.joins(:taggings).where(taggings: {id: n.strip}).map(&:tagname).join(", ")
            new_list <<  Tag.joins(:taggings).where(taggings: {id: n.strip}).pluck(:tagname)#map(&:tagname).join(", ")
        end
        new_list.flatten!
    end

    def possible_answers
        tagging_responses.join(', ')
    end

    def set_correct_answer
        set_downcase
        if response_correct?
            self.correct = true
        else
            self.correct = false
        end
    end

    def response_correct?
        tagging_responses.include?(emotion)
    end

    def response_correct_as_string
        self.correct ? "Yes" : "No"
    end

    def matched_image_id
        this_tagging_id = taglist[0]
        Content.joins(:taggings).where(taggings: {id: this_tagging_id}).map(&:id).join(", ")
    end

    private

        def set_downcase
            self.emotion.downcase!
        end

        def only_letters
            letters = emotion =~ /^[a-zA-Z]+$/
            errors.add(:emotion, 'must have letters only')
        end

end
