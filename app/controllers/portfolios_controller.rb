class PortfoliosController < ApplicationController

  before_action :authorize_user!

  add_breadcrumb "Home", :root_path
  add_breadcrumb "My Portfolio", :portfolios_path

  def index
    @portfolio = current_user.stocks
  end

  def show
  end
end
