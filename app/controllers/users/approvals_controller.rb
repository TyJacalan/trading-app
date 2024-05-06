class Users::ApprovalsController < AdminsController
  include Mailable

  def update
    @user = User.find(user_params[:id])
    approval_status = user_params[:approved] == "true" ? 'approved' : 'unapproved'

    if @user.update(user_params)
      invalidate_cache
      send_user_notification(approval_status)
      redirect_to admin_users_path, notice: "#{@user.first_name} has been #{approval_status}."
    else
      redirect_to '/500'
    end
  end
  
  private
 
  def user_params
    params.require(:user).permit(:id, :approved)
  end

  def send_user_notification(approval_status)
    if approval_status == 'approved'
        notify_user(:approved_user_email)
    else
        notify_user(:declined_user_email)
    end
  end
end
