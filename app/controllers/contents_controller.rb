require 'dropbox_sdk'

class ContentsController < ApplicationController

    # around_filter :authorized_user?, only: [:show, :edit, :update, :destroy, :set_new_content]
    before_filter :authorized_user?, only: [:new]
    before_action :set_content, only: [:show, :edit, :update, :destroy]#, :new]#, :create]#, :set_new_content]
    skip_before_filter :verify_authenticity_token, :only => :create

  # GET /contents
  # GET /contents.json

  def index
        # if user_signed_in?
        #     @contents = Content.where(['user_id = ? OR is_public = ?', current_user.id, 'true']).by_height.page(params[:page])
        #     # @content = current_user.contents.new
            # @content = current_user.contents.new(params[:content])
        # end
      # else
    #     # @contents = Content.where(is_public: 'true').by_height.page(params[:page])
    # end
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

  # def selected_tags_for_students
  #   # Tag.select("tags.*").joins(:taggings).group("tags.id")
  #   # @contents = Content.joins(:tags).
  #   # @all_contents = Content.select("contents.*").joins(:taggings).group("tags.id")
  #   # redirect_to selected student

  #   # puts "#{params[:tag_ids]}"
  #   session[:collected_tag_ids] = Hash.new
  #   session[:collected_tag_ids] = params[:tag_ids]

  #   puts "#{session[:collected_tag_ids]}"

  #   # @selected_contents = Content.joins(:tags).where(tags: {id: params[:tag_ids]}).updated

  #   # respond_to do |format|
  #   #     format.js
  #   # end

  # end

  # GET /contents/new
  def new
    puts "creates new content: begin"
    # @content = Content.new
    @content = current_user.contents.new(params[:content])
    puts "creates new content"
    # respond_to do |format|

        # format.html { render :layout => false }
    #     # format.html(render partial: 'new')
    #     # format.xml  { render :xml => @messages }
    #     # format.json {render json: @student}
    #     # format.js
    # end
  end

  # GET /contents/set_new_content
  def set_new_content
    # @content = current_user.contents.new(params[:content])
  end

  # GET /contents/1/edit
  def edit
  end

  # POST /contents
  # POST /contents.json
  def create
    # @content = Content.new(content_params)
    puts " create action for content before build"
    @content = current_user.contents.build(content_params)
    # @content = current_user.contents.new(content_params)
    puts " create action for content after build"

    if @content.save
        respond_to do |format|

            format.html { redirect_to @content, notice: 'Content was successfully created.' }
            # format.json { render :show, status: :created, location: @content }
            # format.js   #{ render action: 'show', status: :created, location: @content }
        end
    else
        flash[:danger] = "boo"
            # #format.html { render :new }
            ## format.json { render json: @content.errors, status: :unprocessable_entity }
            # format.js   { render json: @content.errors, status: :unprocessable_entity }
          ## end
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update

    if params[:commit].to_i > 0

        respond_to do |format|
          if @content.update_attributes(update_selected)
            format.html do |f|
                flash[:notice] = "Content was successfully updated. #{update_selected}"
                puts "params here: #{update_selected}"
                redirect_to :back and return
            end
            format.json { render :show, status: :ok, location: @content }
          else
            format.html { render :edit }
            format.json { render json: @content.errors, status: :unprocessable_entity }
          end
        end
    else
        respond_to do |format|
          if @content.update(content_params)
            format.html { redirect_to @content, notice: 'Content was successfully updated.' }
            format.json { render :show, status: :ok, location: @content }
          else
            format.html { render :edit }
            format.json { render json: @content.errors, status: :unprocessable_entity }
          end
        end
    end
  end


  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content.destroy
    respond_to do |format|
      format.html { redirect_to contents_url, notice: 'Content was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content
        # if !current_user.guest?
            # puts "LLALLA"
            @content = Content.find(params[:id])
        # else
            # puts 'GUEST'
            # render :js => { 'alert("Sorry, but you are not authorized to upload images." + "\n\n"+"Please do sign up first!");' }

            # render partial:'shared/authorization_error'
            # respond_to do |format|
                # format.js { render :js => 'alert("Sorry, but you are not authorized to upload images."+
                #     "\n\n"+"Please do sign up first!");' }
            # end
        # end
    end

    def authorized_user?
        if current_user.guest?
            respond_to do |format|
                format.js { render :js => 'alert("Sorry, but you are not authorized to upload images."+
                    "\n\n"+"Please do sign up first!");' }
            end
            # respond_to do |format|
            #     format.js { render :js => '$( "#dialog" ).dialog( "open" );' }
            # end
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
