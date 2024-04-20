class StocksSearchController < StocksController
  def show
    query = params[:query].present? ? params[:query].downcase : '*'
    type = params[:as]

    @stocks = cache_all_stocks
    @suggestions = @stocks.select do |stock|
      stock[:symbol].downcase.include?(query) || stock[:name].downcase.include?(query)
    end

    render turbo_stream:
      turbo_stream.update('suggestions', 
                          partial: 'stocks_search/suggestions',
                          locals: { type: type })
  end
end
