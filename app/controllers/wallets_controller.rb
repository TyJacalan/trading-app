class WalletsController < ApplicationController
  before_action :authorize_user!

  def index
    @wallet = Wallet.new
    @balance = current_user.balance
  end

  def create
    @wallet = Wallet.new(wallet_params)

    if @wallet.save
      case @wallet.transaction_type.to_sym
      when :deposit
        result = Wallet.deposit(current_user, @wallet.amount)
      when :withdraw
        result = Wallet.withdraw(current_user, @wallet.amount)
      end

      if result[:status]
        flash.now[:notice] = "#{params[:wallet][:transaction_type].capitalize} successful!"
      else
        flash.now[:alert] = result[:error] || "Transaction failed"
      end
    else
      flash.now[:alert] = @wallet.errors.full_messages.join(", ")
    end

    respond_to do |format|
      format.turbo_stream
    end
  rescue StandardError => e
    error_message = e.message
    respond_to do |format|
      format.turbo_stream { flash.now[:alert] = "#{error_message}" }
    end
  end

  private

  def wallet_params
    params.require(:wallet).permit(:amount, :transaction_type).merge(user_id: current_user.id)
  end
end
