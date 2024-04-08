class Admin::UserRolesController < AdminsController
  include UserCacheManagement

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      invalidate_cache
      redirect_to admin_users_path, notice: "#{@user.first_name}'s role was changed to #{@user.role}"
    else
      redirect_to '/500'
    end
  end

  private

  def user_params
    params.require(:user).permit(:role)
  end
end
