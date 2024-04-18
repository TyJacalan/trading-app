class PortfoliosController < ApplicationController

  before_action :authorize_user!
  before_action :set_portfolio
  before_action :set_stock_api

#  add_breadcrumb "Home", :root_path
  #add_breadcrumb "My Portfolio", :portfolios_path

  def index
    @total_value = @portfolio.sum { |stock| stock[:value] }
    @chart_data = @portfolio.map { |stock| [stock[:symbol], stock[:value]] }
  end

  def show
  end
end
