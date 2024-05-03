class Admin::TransactionsController < AdminsController
  def index
    transactions ||= filter_transactions(params[:filter])

    @transactions = transactions.order(created_at: :desc).page(params[:page]).per(20)
  end

  private

  def filter_transactions(filter)
    case filter
    when 'buy'
      Transaction.buys
    when 'sell'
      Transaction.sells
    when 'deposit'
      Transaction.deposits
    when 'withdraw'
      Transaction.withdrawals
    else
      Transaction
    end
  end
end
