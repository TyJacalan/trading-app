# frozen_string_literal: true

class TransactionsController < ApplicationController # rubocop:disable Style/Documentation
  before_action :authorize_user!
  before_action :set_transaction, only: %i[new create]


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
    @transaction = current_user.transactions.build(transaction_params)

    if @transaction.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.turbo_stream { flash[:notice] = "#{@transaction.transaction_type.capitalize} successful!" }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { flash[:alert] = "#{@transaction.errors.full_messages.join(', ')}" }
      end
    end
  end

  private

  def set_transaction
    @transaction_type = params[:transaction_type].present? ? params[:transaction_type] : ''
  end

  def transaction_params
    @transaction_params ||= params.require(:transaction)
                                  .permit(:symbol, :price, :quantity, :transaction_type, :currency)
                                  .merge(user_id: current_user.id)
  end
end
