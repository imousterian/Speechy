class StaticPagesController < ApplicationController

    def home

        if user_signed_in?
            @contents = Content.where(['user_id = ? OR is_public = ?', current_user.id, 'true']).by_height.page(params[:page])
            # @content = current_user.contents.new
            @content = current_user.contents.new(params[:content])
        end

    end

    def help
    end

    def about
    end

    def contact
    end

end
