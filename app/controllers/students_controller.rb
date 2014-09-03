class StudentsController < ApplicationController

    respond_to :html, :js, :json
    before_action :set_student, only: [:show, :edit, :update, :destroy, :show_response, :show_summary, :show_graph, :show_chart, :show_selected]
    helper_method :sort_column, :sort_direction

    def index
        @students = Student.where(:user_id => current_user.id).sorted_name
    end

    def show_summary
        @responses = @student.student_responses.order(sort_column + ' ' + sort_direction)

        params[:datas] = @student.percentages.to_json

        respond_to do |format|
            format.html
            format.json { render json: params[:datas] }
            format.csv { send_data @student.to_csv}
            format.xls { send_data @student.to_csv(col_sep: "\t") }
        end
    end

    def show
        session[:current_student] = Hash.new
        session[:current_student] = @student.id

        respond_to do |format|
            format.html
        end
    end

    def show_selected
        @selected_contents = Content.joins(:tags).where(tags: { id: params[:tag_ids]}).belongs_to_user(current_user.id)
        respond_to do |format|
            format.js
        end
    end

    def show_response
        @student_response = @student.student_responses.build
        respond_to do |format|
            format.js
        end
    end

    def new
        @student = current_user.students.new(params[:student])
        respond_to do |format|
            format.html { render :layout => false }
        end
    end

    def edit
        @student = Student.find(params[:id])
    end

    def create

        @student = current_user.students.build(student_params)

        if @student.save
            respond_to do |format|
                format.html { redirect_to :back }
                format.js { render :js => "window.location = 'students'" }
            end
        else
            flash[:danger] = "boo"
        end
    end

    def update
        respond_to do |format|
            if @student.update(student_params)
                format.html { redirect_to students_url }
                format.js { render :js => "window.location = 'students'" }
            else
                format.html { render :edit }
                format.json { render json: @student.errors, status: :unprocessable_entity }
                format.js
            end
        end
    end

    def destroy
        @student.destroy
        respond_to do |format|
            format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
        def set_student
            @student = Student.find(params[:id])
        end

    # Never trust parameters from the scary internet, only allow the white list through.
        def student_params
            params.require(:student).permit(:name)
        end

        def sort_column
            @student.student_responses.column_names.include?(params[:order_to_sort_by]) ? params[:order_to_sort_by] : "created_at"
        end

        def sort_direction
            %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
        end
end
