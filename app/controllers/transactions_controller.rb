# frozen_string_literal: true

class TransactionsController < ApplicationController # rubocop:disable Style/Documentation
  before_action :authorize_user!

  def index
    @transactions = current_user.transactions.page(params[:page]).per(20)
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
