class StocksDetailsController < StocksController
  def show
    @stock_chart = format_chart_data(@client.chart(params[:symbol], '1y', chart_close_only: true))
    @stock = fetch_stock(params[:symbol])
    @transaction = Transaction.new(transaction_type: params[:transaction_type])

    render turbo_stream: [
      turbo_stream.update('details', 
                          partial: 'stocks_details/info', 
                          locals: { details: @stock, chart_data: @stock_chart }),
      turbo_stream.update('transactions_form',
                          partial: 'transactions/form',
                          locals: { stock: @stock })]
  end
end
