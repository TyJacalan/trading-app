class AdminsController < ApplicationController
  before_action :authorize_admin!
  include UserCacheable

  def index
    @transactions ||= Transaction.purchases
    @users ||= User.all

    @transactions_summary ||= @transactions.group(:transaction_type).count
    @transactions_count ||= @transactions.count
    @buy_count ||= @transactions_summary['buy']
    @sell_count ||= @transactions_summary['sell']
    @purchases_volume ||= @transactions.sum(:value)

    @users_count ||= @users.count
    @approved_users_count ||= @users.approved.count
    @pending_users_count ||= @users.pending.count
  end

  def show
  end
end

