# frozen_string_literal: true

require_relative '../../services/iex_api' # Require the IEXApi class

module StocksConcern # rubocop:disable Style/Documentation
  extend ActiveSupport::Concern

  included do
    before_action :set_stock_api

    def fetch_stock(symbol)
      @client.quote(symbol)
    end

    def map_stock_list(stock_list)
      stock_list.map do |stock|
        symbol = stock.symbol
        { symbol:,
          company_name: stock.company_name,
          price: stock.latest_price,
          logo_url: cache_image(symbol),
          change: stock.change_percent_s }
      end
    end

    def cache_all_stocks
      Rails.cache.fetch('stock_search_data', expires_in: 1.hour) do
        iex_api = IEXApi.new
        response = iex_api.all_stocks
        stocks = response.success? ? response.parsed_response : []
        stocks.map { |stock| { symbol: stock['symbol'], name: stock['name'] } }
      end
    end

    def chart_stock(symbol)
      {
        symbol:,
        logo_url: cache_image(symbol),
        company: @client.company(symbol),
        quote: @client.quote(symbol),
        chart_data: format_chart_data(@client.chart(symbol, '1y', chart_close_only: true)),
        news: @client.news(symbol)
      }
    end

    def format_chart_data(chart_data)
      chart_data.map { |data| [data.date, data.close] }
    end

    def cache_news(symbol, quantity = nil)
      Rails.cache.fetch("#{symbol}_news", expires_in: 1.hours) do
        news = if quantity
                 @client.news(symbol, quantity)
               else
                 @client.news(symbol).last
               end

        news.map do |article|
          {
            datetime: article.datetime,
            headline: article.headline,
            image: article.image,
            summary: article.summary,
            source: article.source
          }
        end
      end
    end

    def display_all_news
      Rails.cache.fetch('index_news', expires_in: 1.hour) do
        iex_api = IEXApi.new
        response = iex_api.all_news
        news = response.success? ? response.parsed_response : []
        news.map do |article|
          {
            datetime: article['datetime'],
            headline: article['headline'],
            image: article['image'],
            summary: article['summary'],
            source: article['source']
          }
        end
      end
    end

    def display_sector_performance
      iex_api = IEXApi.new
      response = iex_api.sector_performance
      perf = response.success? ? response.parsed_response : []
      perf.map do |sec|
        {
          name: sec['name'],
          performance: sec['performance'],
          symbol: sec['symbol'],
          type: sec['type'],
          lastUpdated: sec['lastUpdated']
        }
      end
    end

    def cache_image(symbol)
      Rails.cache.fetch("#{symbol}_image", expires_in: 24.hours) do
        @client.logo(symbol)&.url
      end
    end
  end
end
