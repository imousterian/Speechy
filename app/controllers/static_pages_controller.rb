class StaticPagesController < ApplicationController

    def home

        if user_signed_in?
            # @contents = Content.where(['user_id = ? OR is_public = ?', current_user.id, 'true']).by_height.page(params[:page])
            @content = current_user.contents.new(params[:content])
            if params[:tag]
                # @contents = Content.joins(:tags).where(tags: {tagname: params[:tag]}).by_height.page(params[:page])
                @contents = Content.belongs_to_user(current_user.id).joins(:tags).
                                    where(tags: {tagname: params[:tag]}).by_height.page(params[:page])
            else
                @contents = Content.belongs_to_user(current_user.id).by_height.page(params[:page])
            end
        end

    end

    def help
    end

    def about
    end

    def contact
    end

end
