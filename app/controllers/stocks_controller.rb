class StocksController < ApplicationController
  before_action :authorize_user!
  before_action :set_stock_api, only: [:index]

  def index
    @quote = @client.price('MSFT')
  end

  def show
  end
end
