class Admin::TransactionsController < AdminsController
  def index
    @transactions = Transaction.order(created_at: :desc)
  end

  def show
    @transaction = Transaction.find(params[:id])
    @user = User.find(@transaction.user_id)
  end
end
