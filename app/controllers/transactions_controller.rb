# frozen_string_literal: true

class TransactionsController < ApplicationController # rubocop:disable Style/Documentation
  before_action :authorize_user!

  def index
    add_breadcrumb "Home", :root_path
    add_breadcrumb "My Transactions", :transactions_path

    filter = params[:filter]
    transactions = case filter
                 when 'buy'
                   current_user.transactions.buys
                 when 'sell'
                   current_user.transactions.sells
                 else
                   current_user.transactions
                 end

    @transactions = transactions.order(created_at: :desc).page(params[:page]).per(20)

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream
        turbo_stream.update('transactions',
                            partial: 'transactions/user_transactions_table')
    end

  end

  def new
    @transaction = Transaction.new(transaction_type: params[:transaction_type])
    @stock = []
  end

  def create
    @transaction = Transaction.new(transaction_params)

    transaction = @transaction.transaction_type == 'buy' ? Transaction.buy(current_user, transaction_params) : Transaction.sell(current_user, transaction_params)

    if transaction[:status]
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "#{transaction_params[:transaction_type].capitalize} successful!" }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = transaction[:error] || "Transaction failed" }
      end
    end
  rescue StandardError => e
    error_message = e.message
    respond_to do |format|
      format.turbo_stream { flash.now[:alert] = "#{error_message}" }
    end
  end

  private

  def transaction_params
    @transaction_params ||= params.require(:transaction)
                                  .permit(:symbol, :price, :quantity, :transaction_type, :currency)
                                  .merge(user_id: current_user.id)
  end
end
