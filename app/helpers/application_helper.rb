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

    def sortable(column, title=nil)
        title ||= column.titleize
        css_class = (column == sort_column) ? "current #{sort_direction}" : nil
        direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
        link_to title, {:order_to_sort_by => column, :direction => direction}, {:class => css_class}
    end
end
