class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_action :authenticate_user!, except: [:create_guest_user]

    def current_student
        Student.find_by(:id => session[:current_student])
    end

    def create_guest_user
        u = User.new { |user| user.guest = true }
        u.email = "guest_#{Time.now.to_i}#{rand(100)}@example.com"
        u.save!(:validate => false)

        # create a fake student
        u.students.build(name: "Sample Student")

        sign_in(:user, u)
        flash[:notice] = 'Welcome, Guest! Your guest account will be available for 24 hours or until you close the browser.'
        redirect_to root_path
    end
end
