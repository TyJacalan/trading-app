class StocksDetailsController < StocksController
  def show
    @stock_chart = format_chart_data(@client.chart(params[:symbol], '1y', chart_close_only: true))
    @stock = fetch_stock(params[:symbol])
    @transaction = Transaction.new
    @stock_balance = current_user.stocks.find_by(symbol: params[:symbol])

    if @stock_balance
      @stock_balance = @stock_balance.quantity
    else
      @stock_balance = 0
    end

    render turbo_stream:[
      turbo_stream.update('details',
                          partial: 'stocks_details/info',
                          locals: { details: @stock, chart_data: @stock_chart, balance: @stock_balance }),
      turbo_stream.update('transaction_buy_form',
                          partial: 'transactions/form',
                          locals: { transaction: @transaction, stock: @stock, transaction_type: 'buy' }),
      turbo_stream.update( 'transaction_sell_form',
                          partial: 'transactions/form',
                          locals: { transaction: @transaction, stock: @stock, transaction_type: 'sell' }),
      turbo_stream.update('suggestions')]
  end
end
