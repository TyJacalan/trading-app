# frozen_string_literal: true

class StocksController < ApplicationController
  before_action :authorize_user!
  before_action :set_stock_api, only: %i[index show]

  def index
    stock_list = @client.stock_market_list(:iexvolume, listLimit: 100)
    @stocks = stock_list.map do |stock|
      symbol = stock.symbol
      { symbol:,
        company_name: stock.company_name,
        price: stock.latest_price,
        logo_url: @client.logo(symbol).url,
        change: stock.change_percent_s }
    end
  end

  def show
    symbol = params[:symbol]

    @stock = {
      symbol:,
      logo_url: @client.logo(symbol)&.url,
      company: @client.company(symbol),
      quote: @client.quote(symbol),
      chart_data: format_chart_data(@client.chart(symbol, '1y', chart_close_only: true)),
      news: @client.news(symbol)
    }
  end

  private

  def format_chart_data(chart_data)
    chart_data.map { |data| [data.date, data.close] }
  end
end
