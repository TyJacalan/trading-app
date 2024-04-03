class Admin::UserRolesController < AdminsController
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to admin_users_path, notice: "User role successfully updated." }
      end
    else
      render admin_users_path, alert: "User role was not updated!"
    end
  end

  private

  def user_params
    params.require(:user).permit(:role)
  end
end
