# frozen_string_literal: true

class StocksController < ApplicationController
  before_action :authorize_user!
  include StocksConcern

  def index
    @transaction = Transaction.new
    @stocks = cache_all_stocks.map { |stock| { value: stock[:symbol], name: stock[:name] } }
    @markets = display_sector_performance.sort_by { |market| market['name'] }
    @perf_chart = @markets.map { |sector| [ sector['name'], sector['performance'] ] }
  end

  def show
    @stock = chart_stock(params[:id])
    @news_feed = cache_news(params[:id], 7)
  end
end
