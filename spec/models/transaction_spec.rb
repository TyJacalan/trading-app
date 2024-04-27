require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { users(:valid_user) }
  fixtures :transactions

  def transaction_params(fixture)
    transaction = transactions(fixture)
    {
      symbol: transaction.symbol,
      price: transaction.price,
      quantity: transaction.quantity,
      transaction_type: transaction.transaction_type,
      currency: transaction.currency,
      user_id: transaction.user_id
    }
  end

  describe 'buy' do
    it "should create a new buy transaction and update the user's stocks" do
      expect {
        Transaction.buy(user, transaction_params(:buy_stock))
      }.to change(Transaction, :count).by(1)
        .and change(user.stocks, :count).by(1)
    end
  end

  describe 'sell' do
    it 'should create a new sell transaction and update stock' do
      expect {
        Transaction.buy(user, transaction_params(:buy_stock))
        Transaction.sell(user, transaction_params(:sell_stock))
      }.to change(Transaction, :count).by(2)
        .and change(user.stocks, :count).by(1)
    end

    it 'should raise an error if the stock does not exist in the portfolio' do
      expect {
        Transaction.sell(user, transaction_params(:sell_stock))
      }.to raise_error(StandardError, "Stock not in Portfolio")
    end

    it 'should raise an error if the quantity in the portfolio is insufficient' do
      expect {
        Transaction.buy(user, transaction_params(:buy_stock))
        Transaction.sell(user, transaction_params(:sell_stock_two))
      }.to raise_error(StandardError, "Insufficient quantity to sell.")
    end
  end
end
