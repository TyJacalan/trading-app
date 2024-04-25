class StocksTablesController < StocksController
  def show
    filter = params[:filter]
    stock_list = case filter
                 when 'gainers'
                   @client.stock_market_list(:gainers, listLimit: 10)
                 when 'losers'
                   @client.stock_market_list(:losers, listLimit: 10)
                 when 'most-active'
                   @client.stock_market_list(:mostactive, listLimit: 10)
                 else
                   @client.stock_market_list(:iexvolume, listLimit: 10)
                 end
    @stocks = map_stock_list(stock_list)
    @name = (filter ? filter.gsub('-', ' ').to_s.titleize : :mostactive.to_s.titleize)
  end
end
