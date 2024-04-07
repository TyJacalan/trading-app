class StocksTablesController < StocksController
  def show
    stock_list = case params[:filter] 
                 when 'gainers'
                   @client.stock_market_list(:gainers)
                 when 'losers'
                   @client.stock_market_list(:losers)
                 else
                   @client.stock_market_list(:mostactive)
                 end
    @stocks = map_stock_list(stock_list)
    @name = params[:filter].gsub("-", " ").titleize
  end
end
