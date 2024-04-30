class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :redirect_user

  def index
  end
  
  private

  def redirect_user
    if current_user && current_user.role == 'admin'
      redirect_to admins_path
    elsif current_user && current_user.role == 'standard'
      redirect_to home_path
    end
  end
end
