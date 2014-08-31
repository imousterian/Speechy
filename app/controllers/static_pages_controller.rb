class StaticPagesController < ApplicationController

    skip_before_filter :authenticate_user!

    def home
        if user_signed_in?
            @content = current_user.contents.new(params[:content])
            if params[:tag]
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
