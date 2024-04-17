class StocksDetailsController < StocksController
  def show
    @stock_chart = format_chart_data(@client.chart(params[:symbol], '1y', chart_close_only: true))
    @stock = fetch_stock(params[:symbol])

    render turbo_stream: 
      turbo_stream.update('details', 
                          partial: 'stocks_details/info', 
                          locals: { details: @stock, chart_data: @stock_chart })
  end
end
