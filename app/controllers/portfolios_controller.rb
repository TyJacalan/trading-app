class PortfoliosController < ApplicationController
  include StocksConcern

  before_action :authorize_user!

  add_breadcrumb "Home", :root_path
  add_breadcrumb "My Portfolio", :portfolios_path

  def index
    @portfolio = format_portfolio(current_user.stocks)
    @chart_data = @portfolio.map { |stock| [stock[:symbol], stock[:value]] }
    @total_value = @portfolio.sum { |stock| stock[:value] }
  end

  def show
  end
end
