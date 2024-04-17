class StocksArticlesController < StocksController
  def show
    symbol = params[:symbol].presence || 'MARKET'
    @news_feed = cache_news(symbol, 7)
    # @news_feed = display_all_news
  end
end
