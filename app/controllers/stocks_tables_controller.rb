class StocksTablesController < StocksController
  def show
    stock_list = case params[:filter] 
                 when 'gainers'
                   @client.stock_market_list(:gainers, listLimit: 25)
                 when 'losers'
                   @client.stock_market_list(:losers, listLimit: 25)
                 else
                   @client.stock_market_list(:mostactive, listLimit: 25)
                 end
    @stocks = map_stock_list(stock_list)
    @name = params[:filter].gsub("-", " ").titleize
  end
end
