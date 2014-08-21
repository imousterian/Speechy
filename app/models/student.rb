class Student < ActiveRecord::Base
    belongs_to :user
    has_many :student_responses, :dependent => :destroy

    validates :name, :presence => true, :uniqueness => true

    def to_csv
        CSV.generate do |csv|
            csv << ['Image ID', 'Recorded Emotion', 'Matched', 'Possible Answers' ]
            self.student_responses.each do |response|
                csv << [response.matched_image_id, response.emotion, response.response_correct_as_string, response.possible_answers]
            end
        end
    end

    def percentage_of
        total = 0
        truths = 0
        self.student_responses.each do |response|
            total += 1
            if response.response_correct?
                truths += 1
            end
        end
        correct = (truths/total.to_f)*100.0
        wrong = 100 - correct
        return [ correct, wrong ]
    end
end
