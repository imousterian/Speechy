class StudentResponsesController < ApplicationController

    def create
        @student_response = current_student.student_responses.build(student_response_params)
        @student_response.set_correct_answer

        respond_to do |format|
            if @student_response.save

                if !@student_response.correct
                    format.js { render :js => '$( "#dialog-wrong" ).dialog( "open" );' }
                else
                    format.js { render :js => '$( "#dialog-correct" ).dialog( "open" );' }
                end
                format.js { render nothing: true }
            else
                format.js
            end
        end
    end

    private
        # Never trust parameters from the scary internet, only allow the white list through.
        def student_response_params
            params.require(:student_response).permit(:emotion, :taglist)
        end
end
