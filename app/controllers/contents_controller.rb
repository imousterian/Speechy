require 'dropbox_sdk'

class ContentsController < ApplicationController

  before_action :set_content, only: [:show, :edit, :update, :destroy, :set_new_content]

  # GET /contents
  # GET /contents.json

  # this action is now called in static pages
  def index
    if user_signed_in?
        # @contents = Content.where(['user_id = ? OR is_public = ?', current_user.id, 'true']).by_height.page(params[:page])
    else
        # @contents = Content.where(is_public: 'true').by_height.page(params[:page])
    end


  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @content = Content.find(params[:id])
  end

  def summary
    #/contents/tag
    # when I click on a tag
    # it will take me to a controller

    @contents = Content.joins(:tags).where(tags: {tagname: params[:tagname]}).updated
    respond_to do |format|
        format.html
    end

  end

  def selected_tags_for_students
    # Tag.select("tags.*").joins(:taggings).group("tags.id")
    # @contents = Content.joins(:tags).
    # @all_contents = Content.select("contents.*").joins(:taggings).group("tags.id")
    # redirect_to selected student

    # puts "#{params[:tag_ids]}"
    session[:collected_tag_ids] = Hash.new
    session[:collected_tag_ids] = params[:tag_ids]

    puts "#{session[:collected_tag_ids]}"

    # @selected_contents = Content.joins(:tags).where(tags: {id: params[:tag_ids]}).updated

    # respond_to do |format|
    #     format.js
    # end

  end

  # GET /contents/new
  def new
    puts "creates new content: begin"
    # @content = Content.new
    @content = current_user.contents.new(params[:content])
    puts "creates new content"
  end

  # GET /contents/set_new_content
  def set_new_content
    @content = current_user.contents.new(params[:content])
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
    puts " create action for content after build"

    respond_to do |format|
      if @content.save
        format.html { redirect_to @content, notice: 'Content was successfully created.' }
        format.json { render :show, status: :created, location: @content }
      else
        format.html { render :new }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update

    # puts "Lalal #{params[:commit]} #{params[:commit].to_i.nil?} #{'a'.to_i.nil?}"

    if params[:commit].to_i > 0

        # session[:updated] = params[:id]

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
      @content = Content.find(params[:id])
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
