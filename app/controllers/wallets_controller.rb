class WalletsController < ApplicationController
  before_action :authorize_user!

  def index
    @transaction = Transaction.new(transaction_type: params[:transaction_type])
    @balance = current_user.wallet.balance
  end
end
