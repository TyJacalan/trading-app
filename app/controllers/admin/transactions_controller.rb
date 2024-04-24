class Admin::TransactionsController < AdminsController
  def index
    @transactions = Transaction.order(created_at: :desc).page(params[:page]).per(20)
  end
end
