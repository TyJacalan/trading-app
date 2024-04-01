class AdminsController < ApplicationController
  before_action :authorize_admin!

  def index
  end
  
  def show
  end
end
