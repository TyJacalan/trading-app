class StocksTablesController < StocksController
  def show
    filter = params[:filter]
    stock_list = case filter
                 when 'gainers'
                   @client.stock_market_list(:gainers, listLimit: 25)
                 when 'losers'
                   @client.stock_market_list(:losers, listLimit: 25)
                 when 'iexvolume'
                   @client.stock_market_list(:iexvolume, listLimit: 25)
                 else
                   @client.stock_market_list(:mostactive, listLimit: 25)
                 end
    @stocks = map_stock_list(stock_list)
    @name = (filter ? filter.gsub('-', ' ').to_s.titleize : :mostactive.to_s.titleize)
  end
end
