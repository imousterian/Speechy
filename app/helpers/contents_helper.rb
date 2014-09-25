module ContentsHelper

    def errors_helper(content)
        content.errors[:image].map{|i| i}.join(" ")
    end
end
