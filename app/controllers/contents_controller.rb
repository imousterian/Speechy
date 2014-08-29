require 'dropbox_sdk'

class ContentsController < ApplicationController

    before_filter :authorized_user?, only: [:new]
    before_action :set_content, only: [:show, :edit, :update, :destroy]
    skip_before_filter :verify_authenticity_token, :only => :create

    def summary_index
        @contents = current_user.contents
    end

    def index
    end

    def show
        @content = Content.find(params[:id])
    end

      # def summary
      # not to be used anymore??, as of Tue 26
      #   @contents = Content.joins(:tags).where(tags: {tagname: params[:tagname]}).updated
      #   respond_to do |format|
      #       format.html
      #   end
      # end

    def new
        @content = current_user.contents.new(params[:content])
    end

    # GET /contents/set_new_content
    def set_new_content
        # @content = current_user.contents.new(params[:content])
    end

    def edit
        @content = Content.find(params[:id])
    end

    def create
        @content = current_user.contents.build(content_params)
        if @content.save
            respond_to do |format|
                format.html { redirect_to :back, notice: 'Content was successfully created.' }
                format.js
            end
        else
            flash[:danger] = "boo"
        end
    end

    def update
        respond_to do |format|
            if @content.update(content_params)
                format.html { redirect_to @content, notice: 'Content was successfully updated.' }
                format.json { render :show, status: :ok, location: @content }
                format.js { render :js => "window.location.replace('#{url_for(:controller => :contents, :action => :summary_index)}');" }
            else
                format.html { render :edit }
                format.json { render json: @content.errors, status: :unprocessable_entity }
                format.js
            end
        end
    end

    def destroy
        @content.destroy
        respond_to do |format|
            format.html { redirect_to :back, notice: 'Content was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
        def set_content
            @content = Content.find(params[:id])
        end

        def authorized_user?
            if current_user.guest?
                respond_to do |format|
                    format.js { render :js => 'alert("Sorry, but you are not authorized to upload images."+
                        "\n\n"+"Please do sign up first!");' }
                end
            end
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def content_params
            params.require(:content).permit(:ctype, :is_public, :dblink, :user_id, :image, :tag_list)
        end

        def update_selected
            u = params[:commit]
            submission = { :ctype => u }
        end

end
