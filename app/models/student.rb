class Student < ActiveRecord::Base
    belongs_to :user
    has_many :student_responses, :dependent => :destroy

    validates :name, :presence => true
    scope :sorted_name,   ->   { order('name ASC') }

    def to_csv(options = {})
        CSV.generate(options) do |csv|
            csv << ['Image ID', 'Recorded Emotion', 'Matched', 'Possible Answers' ]
            self.student_responses.each do |response|
                csv << [response.matched_image_id, response.emotion, response.response_correct_as_string, response.possible_answers]
            end
        end
    end

    def dates
        results = self.student_responses.group("date(created_at)").count.keys
        return results.sort!
    end

    def percentages

        total_responses_by_day = self.student_responses.group("date(student_responses.created_at)").
                            select("student_responses.created_at").count
        responses_by_day = self.student_responses.group("date(student_responses.created_at)").group(:correct).count

        results = Array.new

        responses_by_day.sort_by{|k,v| k[0]}.each do |resp|
            correctness = resp[0][1]
            this_date = resp[0][0]
            summary = resp[1]

            summ = total_responses_by_day.fetch(this_date).to_f
            to_insert = ((summary.to_f / summ) * 100.0).floor

            if to_insert == 100
                if correctness
                    results << {:unit => this_date, :status => "Correct", :val => to_insert}
                    results << {:unit => this_date, :status => "Not correct", :val => (100 - to_insert)}
                else
                    results << {:unit => this_date, :status => "Correct", :val => (100 - to_insert)}
                    results << {:unit => this_date, :status => "Not correct", :val => to_insert}
                end
            else
                if correctness
                    results << {:unit => this_date, :status => "Correct", :val => to_insert}
                    results << {:unit => this_date, :status => "Not correct", :val => (100.0 - to_insert)}
                else
                    # results << {:unit => this_date, :status => "Correct", :val => (to_insert-100)}
                    # results << {:unit => this_date, :status => "Not correct", :val => to_insert}

                end
            end

        end

        return results

    end
end
