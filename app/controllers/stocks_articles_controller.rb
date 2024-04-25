class StocksArticlesController < StocksController
  def show
    symbol = params[:symbol].presence || 'MARKET'
    @news_feed = cache_news(symbol, 3)
  end
end
