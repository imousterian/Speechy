require 'dropbox_sdk'

class ContentsController < ApplicationController

    # around_filter :authorized_user?, only: [:show, :edit, :update, :destroy, :set_new_content]
    before_filter :authorized_user?, only: [:new]
    before_action :set_content, only: [:show, :edit, :update, :destroy]#, :new]#, :create]#, :set_new_content]
    skip_before_filter :verify_authenticity_token, :only => :create

  # GET /contents
  # GET /contents.json
  def summary_index
    @contents = current_user.contents
  end

  def index
  end

  # GET /contents/1
  # GET /contents/1.json
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

  # GET /contents/new
  def new
    @content = current_user.contents.new(params[:content])
  end

  # GET /contents/set_new_content
  def set_new_content
    # @content = current_user.contents.new(params[:content])
  end

  # GET /contents/1/edit
  def edit
    @content = Content.find(params[:id])
  end

  # POST /contents
  # POST /contents.json
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

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update

    # if params[:commit].to_i > 0

    #     respond_to do |format|
    #       if @content.update_attributes(update_selected)
    #         format.html do |f|
    #             flash[:notice] = "Content was successfully updated. #{update_selected}"
    #             redirect_to :back and return
    #         end
    #         format.json { render :show, status: :ok, location: @content }
    #       else
    #         format.html { render :edit }
    #         format.json { render json: @content.errors, status: :unprocessable_entity }
    #       end
    #     end
    # else
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
    # end
  end


  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    # @content.tags.destroy_all
    @content.destroy
        respond_to do |format|
          # format.html { redirect_to contents_url, notice: 'Content was successfully destroyed.' }
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
