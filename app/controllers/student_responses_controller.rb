class StudentResponsesController < ApplicationController

    def create
        # current_student = Student.find_by(:id => session[:current_student])
        # current_student = session[:current_student]
        # puts "#{current_student.class}"
        @student_response = current_student.student_responses.build(student_response_params)
        # if @student_response.save
        #     format.html #{ redirect_to current_student, notice: 'Response saved.' }
        #     # format.json { render :show, status: :created, location: @content }
        #     format.js { render :js => "window.location = 'students'" }
        # else
        #     # @feed_items = []
        #     # render 'static_pages/home'
        # end
        stid = current_student.id
        respond_to do |format|
            if @student_response.save
                format.html { redirect_to current_student, notice: 'Response saved.' }
                format.js { render :js => "window.location = '#{stid}'" }
            end

        end
    end

    private
        # Never trust parameters from the scary internet, only allow the white list through.
        def student_response_params
          params.require(:student_response).permit(:emotion)
        end
end
