class TransactionsController < ApplicationController
  before_action :authorize_user!
  before_action :set_transaction, only: %i[new create]

  def index
    @transactions = current_user.transactions
  end

  def new
    @transaction = Transaction.new(transaction_type: params[:transaction_type])
    @stocks_balance = Transaction.aggregate_balance_by_symbol(current_user.id) || {}
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)

    if @transaction.save
      redirect_to root_path, notice: "#{@transaction_type.capitalize} successful!"
    else
      flash[:alert] = @transaction.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_transaction
    @transaction_type = params[:transaction_type].present? ? params[:transaction_type] : ''
  end

  def transaction_params
    params.require(:transaction)
          .permit(:symbol, :price, :amount, :transaction_type, :currency)
          .merge(user_id: current_user.id)
  end
end
