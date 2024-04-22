# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def create
    logger.debug current_user.role
    if current_user.role == 'admin'
      sign_out current_user
      redirect_to admin_sign_in_path
    else
      super
    end
  end
end
