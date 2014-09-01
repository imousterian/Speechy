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

    # def percentage_of
    #     total = 0
    #     truths = 0
    #     self.student_responses.each do |response|
    #         total += 1
    #         if response.response_correct?
    #             truths += 1
    #         end
    #     end
    #     correct = (truths/total.to_f) * 100.0
    #     wrong = 100 - correct
    #     return [ correct, wrong ]
    # end

    def dates
        results = self.student_responses.group("date(created_at)").count.keys
        # results = self.student_responses.order("date(created_at), DESC").group("date(created_at)").count.keys
        # results = self.student_responses.where(:order => 'DATE(created_at) DESC').group("DATE(created_at)")#.each {|u| puts "#{u[0]} -> #{u[1]}" }
        puts " dates: #{ results }"
        return results.sort!
    end

    def percentages

        total_responses_by_day = self.student_responses.group("date(student_responses.created_at)").
                            select("student_responses.created_at").count
        responses_by_day = self.student_responses.group("date(student_responses.created_at)").group(:correct).count

        hsh = Hash.new
        hsh['Correct'] = []
        hsh['Not correct'] = []
        responses_by_day.sort_by{|k,v| k[0]}.each do |resp|
            correctness = resp[0][1]
            this_date = resp[0][0]
            summary = resp[1]

            puts "#{correctness} #{this_date} #{summary}"

            summ = total_responses_by_day.fetch(this_date).to_f

            to_insert = ((summary / summ) * 100.0).round(0)
            if correctness
                hsh['Correct'] += [ to_insert ]
                if to_insert == 100
                    hsh['Not correct'] += [ 100.0 - to_insert ]
                end
            else
                hsh['Not correct'] += [ to_insert ]
                if to_insert == 100
                    hsh['Correct'] += [false]#[ 100 - to_insert ]
                end
            end
        end
        puts "hash: #{hsh}"
        ress = []
        hsh.each do |key, value|
            ex = Hash.new
            ex["name"] = key
            ex["data"] = value
            ress.push(ex)
        end

        results = Array.new

        # puts "responses_by_day #{responses_by_day}"

        responses_by_day.sort_by{|k,v| k[0]}.each do |resp|
            correctness = resp[0][1]
            this_date = resp[0][0]
            summary = resp[1]

            summ = total_responses_by_day.fetch(this_date).to_f
            to_insert = ((summary.to_f / summ) * 100.0).round(0)

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
                    results << {:unit => this_date, :status => "Not correct", :val => (100- to_insert)}
                else
                    # results << {:unit => this_date, :status => "Correct", :val => (to_insert-100)}
                    # results << {:unit => this_date, :status => "Not correct", :val => to_insert}

                end
            end

        end
        puts "STUFF #{results}"

        # data = [{unit:'a', status:"Stopped / Idle", val: 21.2022222222222222},
        #           {unit: "a", status: "Working", val: 53.3066666666666667}]
        data =  [{:unit=>'Fri, 29 Aug 2014', :status=>"False", :val=>0.0},
                 {:unit=>'Fri, 29 Aug 2014', :status=>"True", :val=>100},
                 {:unit=>'Sat, 30 Aug 2014', :status=>"False", :val=>0.0},
                 {:unit=>'Sat, 30 Aug 2014', :status=>"True", :val=>100},
                 {:unit=>'Sun, 31 Aug 2014', :status=>"False", :val=>38},
                 {:unit=>'Sun, 31 Aug 2014', :status=>"True", :val=>63}]
        return results


    end
end
