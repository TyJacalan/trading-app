class Admin::TransactionsController < AdminsController
  def index
    @transactions = Transaction.all
  end

  def show
  end
end
