class StaticPagesController < ApplicationController


    def home

        if user_signed_in?
            @contents = Content.where(['user_id = ? OR is_public = ?', current_user.id, 'true']).by_height.page(params[:page])
        else
            # actually, not called here because only signed-in users can view the content
            # @contents = Content.where(is_public: 'true').by_height.page(params[:page])
        end

    end

    def help
    end

    def about
    end

    def contact
    end

end