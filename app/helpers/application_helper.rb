module ApplicationHelper

    def tag_cloud(tags, classes)
        max = tags.sort_by(&:count).last
        tags.each do |tag|
          index = tag.count.to_f / max.count * (classes.size - 1)
          yield(tag, classes[index.round])
        end
    end

    def full_title(page_title)
        base_title = "SLP App"
        if page_title.empty?
            base_title
        else
            "#{base_title} | #{page_title}"
        end
    end

    def tag_selection(tags)
        tags.each do |tag|
            yield tag
        end
    end
end
