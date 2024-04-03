class Admin::ApproveRolesController < AdminsController
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to admin_users_path, notice: "#{@user.first_name} has been approved." }
      end
    else
      render admin_users_path, alert: "User approval status was not updated!"
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:approved)
  end
end
