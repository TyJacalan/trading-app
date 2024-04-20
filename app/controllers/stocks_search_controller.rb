class StocksSearchController < StocksController
  def show
    query = params[:query].present? ? params[:query].downcase : '*'
    type = params[:as]

    @stocks = cache_all_stocks
    @suggestions = @stocks.select { |stock| stock[:symbol].downcase.include?(query) }

    render turbo_stream:
      turbo_stream.update('suggestions', 
                          partial: 'stocks_search/suggestions',
                          locals: { type: type })
  end
end
