# frozen_string_literal: true

class StocksController < ApplicationController
  before_action :authorize_user!
  include StocksConcern

  def index
    @transaction = Transaction.new
    @stocks = search_stock_data.map { |stock| { value: stock[:symbol], name: stock[:name]}} || []
    @stocks = cache_all_stocks.map { |stock| { value: stock[:symbol], name: stock[:name] } }
  end

  def show
    @stock = chart_stock(params[:id])
    @news_feed = cache_news(params[:id], 7)
  end
end
