class Users::ApprovalsController < AdminsController
  include AdminConcern

  def update
    Rails.logger.info "User: #{user_params[:id]}"
    @user = User.find(user_params[:id])
    approval_status = user_params[:approved] == "true" ? 'approved' : 'unapproved'

    if @user.update(user_params)
      invalidate_cache
      redirect_to admin_users_path, notice: "#{@user.first_name} has been #{approval_status}."
    else
      redirect_to '/500'
    end
  end
  
  private
 
  def user_params
    params.require(:user).permit(:id, :approved)
  end
end
