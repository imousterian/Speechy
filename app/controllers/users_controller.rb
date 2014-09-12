class UsersController < ApplicationController

    def index
        @users = User.all
    end

    def show
        @user = User.find(params[:id])
    end

    def destroy
        user = User.find(params[:id])
        respond_to do |format|
            if current_user == user && current_user.admin?
                format.html { redirect_to users_path, alert: "Cannot delete admin account."}
            else
                user.destroy
                format.html { redirect_to users_path, notice: "User destroyed."}
            end
        end
    end
end
