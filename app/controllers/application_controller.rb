class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

  # forces the user to redirect to the login page if s/he was not logged in
  # before_action :authenticate_user!
   # before_filter :set_current_user

    def current_student
        Student.find_by(:id => session[:current_student])
    end

end
