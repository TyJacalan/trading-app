# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  def create
    if current_user.role != 'admin'
      sign_out current_user
      redirect_to new_user_session_path
    else
      super
    end
  end
end
