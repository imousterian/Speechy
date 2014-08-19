class StudentResponsesController < ApplicationController

    def create
        # current_student = Student.find_by(:id => session[:current_student])
        # current_student = session[:current_student]
        @student_response = current_student.student_responses.build(student_response_params)

        respond_to do |format|
            if @student_response.save
                # format.html { redirect_to current_student, notice: 'Response saved.' }
                # format.js { render :js => "window.location = '#{stid}'" and return }
                # format.js #{ render :js => :back and return }
                # format.html { redirect_to :back and return }

                format.js { render nothing: true }
                # format.html { render plain: 'OK' }

                @response = @student_response.response_correct?
                if !@response

                else

                end

            end
        end
    end

    private
        # Never trust parameters from the scary internet, only allow the white list through.
        def student_response_params
          params.require(:student_response).permit(:emotion, :taglist)
        end
end
