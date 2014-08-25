class StudentsController < ApplicationController

    respond_to :html, :js, :json

    before_action :set_student, only: [:show, :edit, :update, :destroy, :show_response, :show_summary, :show_graph]

  # GET /students
  # GET /students.json
    def index
        @students = Student.where(:user_id => current_user.id)
    end

    def show_summary
        @responses = @student.student_responses
        respond_to do |format|
            format.html
            format.csv { send_data @student.to_csv}
            # format.xls
            format.xls { send_data @student.to_csv(col_sep: "\t") }
        end
    end

  # GET /students/1
  # GET /students/1.json
    def show
    # session.clear
        session[:current_student] = Hash.new
        session[:current_student] = @student.id
        # puts "#{current_user.id}"
        # @student_response = @student.student_responses.build

        @selected_contents = Content.joins(:tags).where(tags: { selected: '1' }).belongs_to_user(current_user.id)#.updated

        # contents = Content.belongs_to_user(current_user.id)#.joins(:tags).where(tags: { selected: '1' })
        # @selected_contents = contents.joins(:tags).where(tags: { selected: '1' })#.updated
        # @selected_contents = Content.where(['contents.user_id = ? OR is_public = ?', current_user.id, 'true']).joins(:tags).where(tags: { selected: '1' })
        # puts "#{@selected_contents}"
        respond_to do |format|
            format.html
        # format.js { render nothing: true }
        end
    end

    def show_response

        @student_response = @student.student_responses.build
        respond_to do |format|
            format.js
        end
    end

  # GET /students/new
    def new

        @student = current_user.students.new(params[:student])

        respond_to do |format|
            format.html { render :layout => false }
        # format.html(render partial: 'new')
        # format.xml  { render :xml => @messages }
        # format.json {render json: @student}
        # format.js
        end

    end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create

    @student = current_user.students.build(student_params)

    if @student.save
        flash[:notice] = "You've successfully added a student #{@student.name}"
        respond_to do |format|
            # format.html { redirect_to students_url }
            # format.json { render json: @student, status: :created, location: @student }
            # format.js
            format.js { render :js => "window.location = 'students'" }
        end
    else
        flash[:danger] = "boo"
        # format.html { render :new }
        # format.js { render :js => "window.location = 'new'" }
    end

    # respond_with(@student) do |f|
    #      f.html { redirect_to students_url }
    #      f.js
    #     #f.html { render :partial => "form"  }
    #     # f.js { render :index }
    #     # f.html { redirect_to root_path }
    #     # f.html { render :index }
    # end

    # respond_to do |format|
    #   if @student.save
    #     # redirect_to :index
    #      format.html { redirect_to(:action => 'index')}#, notice: 'Student was successfully created.' }
    #     # format.json { render :show, status: :created, location: @student }
    #      format.js
    #   else
    #       format.html { redirect_to(:controller => "students", :action => "create")}
    #      # format.html { render :partial => 'form' }
    #     # format.json { render json: @student.errors, status: :unprocessable_entity }
    #format.js { render :js => @playlist.errors, :status => :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        # format.json { render :show, status: :ok, location: @student }
        # format.js { render :location => "window.location = #{students_path(@student)}" }
        # format.js
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
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
end
