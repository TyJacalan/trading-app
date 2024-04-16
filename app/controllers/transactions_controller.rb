# frozen_string_literal: true

class TransactionsController < ApplicationController # rubocop:disable Style/Documentation
  include TransactionsConcern
  include StocksConcern

  before_action :authorize_user!
  before_action :set_portfolio
  before_action :set_transaction, only: %i[new create]

  def index
    @transactions = current_user.transactions
  end

  def new
    @transaction = Transaction.new(transaction_type: params[:transaction_type])
    @stocks = search_stock_data.map { |stock| { value: stock[:symbol], name: stock[:name]}} || []
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)

    if @transaction.save
      redirect_to root_path, notice: "#{@transaction.transaction_type.capitalize} successful!"
    else
      flash[:alert] = @transaction.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_transaction
    @transaction_type = params[:transaction_type].present? ? params[:transaction_type] : ''
  end

  def transaction_params
    # memoization
    @transaction_params ||= params.require(:transaction)
                                  .permit(:symbol, :price, :quantity, :transaction_type, :currency)
                                  .merge(user_id: current_user.id)
  end
end
