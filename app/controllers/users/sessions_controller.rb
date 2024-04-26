# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def create
    if current_user
      if current_user.role == 'admin'
        sign_out current_user
        redirect_to admin_sign_in_path
      elsif !current_user.approved
        sign_out current_user
        
        flash[:alert] = "Your account is pending admin approval, please wait before signing in."
        redirect_to new_user_session_path
      else
        super
      end
    end
  end
end
