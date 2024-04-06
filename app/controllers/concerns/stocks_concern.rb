module StocksConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_stock_api

    def map_stock_list(stock_list)
      stock_list.map do |stock|
        symbol = stock.symbol
        { symbol:,
          company_name: stock.company_name,
          price: stock.latest_price,
          change: stock.change_percent_s }
      end
    end

    def chart_stock(symbol)
      {
        symbol:,
        logo_url: @client.logo(symbol)&.url,
        company: @client.company(symbol),
        quote: @client.quote(symbol),
        chart_data: format_chart_data(@client.chart(symbol, '1y', chart_close_only: true)),
        news: @client.news(symbol)
      }
    end

    def format_chart_data(chart_data)
      chart_data.map { |data| [data.date, data.close] }
    end
  end
end
