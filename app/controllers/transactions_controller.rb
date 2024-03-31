class TransactionsController < ApplicationController
  before_action :authorize_user!

  def index
    @transactions = Transaction.all
  end

  def show
  end

  def create
  end

  def update
  end
end
