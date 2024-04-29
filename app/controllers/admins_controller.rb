class AdminsController < ApplicationController
  before_action :authorize_admin!
  include UserCacheable

  def index
    @transactions = Transaction
    @transactions_count = @transactions.count
    @buy_count = Transaction.buys.count
    @sell_count = Transaction.sells.count

    @users = User
    @users_count = @users.count
    @approved_users_count = @users.approved.count
    @pending_users_count = @users.pending.count
  end
  
  def show
  end
end
