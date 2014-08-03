class StudentsController < ApplicationController

    respond_to :html, :js

    before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @students = Student.where(:user_id => current_user.id)
    # @student = current_user.students.new(params[:student])

  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new

    @student = current_user.students.new(params[:student])

    respond_to do |format|
        format.html {render :layout => false} # index.html.erb
        # format.xml  { render :xml => @messages }
        format.json {render json: @student}
        format.js
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
        flash[:notice] = "yes"
        respond_to do |format|
            format.html { redirect_to students_url }
            format.json { render json: @student, status: :created, location: @student }
            # format.js
            format.js { render :js => "window.location = 'students'" }
        end
    else
        flash[:danger] = "boo"
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
    # respond_to do |format|
    #   if @student.update(student_params)
    #     format.html { redirect_to @student, notice: 'Student was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @student }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @student.errors, status: :unprocessable_entity }
    #   end
    # end
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
