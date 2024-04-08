# frozen_string_literal: true

class StocksController < ApplicationController
  before_action :authorize_user!
  include StocksConcern

  def index
  end

  def show
    @stock = chart_stock(params[:id])
    @news_feed = cache_news(params[:id], 5)
  end
end
