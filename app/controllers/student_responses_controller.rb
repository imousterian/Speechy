class StudentResponsesController < ApplicationController

    def create
        # current_student = Student.find_by(:id => session[:current_student])
        # current_student = session[:current_student]
        # puts "#{current_student.class}"
        ajax_params = params[:passed_stid]
        puts "TESTTST #{ajax_params}"

        @student_response = current_student.student_responses.build(student_response_params)
        if @student_response.save
            format.html { redirect_to current_student, notice: 'Response saved.' }
            # format.json { render :show, status: :created, location: @content }
            format.js
        else
            # @feed_items = []
            # render 'static_pages/home'
        end
    end

    private
        # Never trust parameters from the scary internet, only allow the white list through.
        def student_response_params
          params.require(:student_response).permit(:emotion)
        end
end
