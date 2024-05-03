# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authorize_user!
  include StocksConcern

  def index
    add_breadcrumb "Home", :home_path
    add_breadcrumb "My Transactions", :transactions_path

    transactions = filter_transactions(params[:filter])

    @transactions = transactions.order(created_at: :desc).page(params[:page]).per(20)

    update_transactions_table
  end

  def new
    @transaction = Transaction.new(transaction_type: params[:transaction_type])
    @stock = []
  end

  def create
    @transaction = Transaction.new(transaction_params)

    transaction_method = determine_transaction_method(@transaction.transaction_type)

    if transaction_method
      transaction = Transaction.send(transaction_method, current_user, transaction_params)
      handle_transaction(transaction)
    else respond_to do |format|
      format.turbo_stream { flash.now[:alert] = "Invalid transaction type!" }
    end
  end
  rescue StandardError => e
    handle_error(e)
  end

  private

  def filter_transactions(filter)
    case filter
    when 'buy'
      current_user.transactions.buys
    when 'sell'
      current_user.transactions.sells
    else
      current_user.transactions
    end
  end

  def update_transactions_table
    respond_to do |format|
      format.html { render :index }
      format.turbo_stream
      turbo_stream.update('transactions',
                          partial: 'transactions/user_transactions_table')
    end
  end

  def transaction_params
    @transaction_params ||= params.require(:transaction)
                                  .permit(:symbol, :price, :quantity, :transaction_type, :currency)
                                  .merge(user_id: current_user.id)
  end

  def determine_transaction_method(transaction_type)
    {
      'buy' => :buy,
      'sell' => :sell,
      'deposit' => :deposit,
      'withdraw' => :withdraw
    }[transaction_type]
  end

  def handle_transaction(transaction)
    if transaction[:status]
      @portfolio = format_portfolio(current_user.stocks)
      @chart_data = @portfolio.map { |stock| [stock[:symbol], stock[:value]] }
      @total_value = @portfolio.sum { |stock| stock[:value] }

      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "#{transaction_params[:transaction_type].capitalize} successful!" }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = transaction[:error] || 'Something went wrong' }
      end
    end
  end

  def handle_error(e)
    error_message = e.message
    respond_to do |format|
      format.turbo_stream { flash.now[:alert] = "#{error_message}" }
    end
  end
end
