class Admin::ApproveRolesController < AdminsController
  include AdminConcern

  def update
    @user = User.find(params[:id])
    approval_status = params[:user][:approved] == "true" ? 'approved' : 'unapproved'

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "#{@user.first_name} has been #{approval_status}."
    else
      redirect_to '/500'
    end
  end
  
  private
 
  def user_params
    params.require(:user).permit(:approved)
  end
end
