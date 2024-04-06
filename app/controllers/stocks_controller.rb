# frozen_string_literal: true

class StocksController < ApplicationController
  before_action :authorize_user!
  include StocksConcern

  def index
    stock_list = @client.stock_market_list(:mostactive)
    @stocks = map_stock_list(stock_list)
  end

  def show
    @stock = chart_stock(params[:symbol])
  end
end
