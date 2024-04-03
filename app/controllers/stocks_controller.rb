class StocksController < ApplicationController
  before_action :authorize_user!
  before_action :set_stock_api, only: %i[index show]

  def index
    symbols = %w[AAPL MSFT GOOGL]
    @stocks = symbols.map do |symbol|
      quote = @client.quote(symbol)
      { symbol:,
        price: @client.price(symbol),
        logo_url: @client.logo(symbol).url,
        change: quote.change_percent_s }
    end
  end

  def show
    symbol = params[:symbol]

    @stock = {
      symbol:,
      price: @client.price(symbol),
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
    # chart.group_by { |date, _| date.to_date }
  end
end
