class StocksArticlesController < StocksController
  def show
    symbol = params[:symbol].presence || 'MARKET'
    @news_feed = cache_news(symbol, 7)
  end
end
