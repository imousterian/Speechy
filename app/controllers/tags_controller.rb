class TagsController < ApplicationController

    before_action :set_tag, only: [:edit, :update, :destroy]

    def index
        @tags = Tag.all
    end

    def new
        @tag = Tag.new
    end

    def edit
    end

    def create
        @tag = Tag.new(tag_params)
        respond_to do |format|
            if @tag.save
                format.html { redirect_to :back }
            else
                format.html { render :new }
                format.json { render json: @tag.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @tag.update(tag_params)
                format.js { render layout: false }
            else
                format.html { render :edit }
                format.json { render json: @tag.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @tag.destroy
        respond_to do |format|
            format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
        def set_tag
            @tag = Tag.find(params[:id])
        end
    # Never trust parameters from the scary internet, only allow the white list through.
        def tag_params
            params.require(:tag).permit(:tagname, :selected)
        end
end
