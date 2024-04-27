require 'rails_helper'

RSpec.describe "Transactions", type: :request do
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
      user_id: user.id
    }
  end

  describe "GET /index" do
    it "renders the transaction page" do
      sign_in user
      get transactions_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /create" do
    context "with valid params" do
      it "creates a new transaction" do
        sign_in user
        expect {
          post transactions_path, params: { transaction: transaction_params(:buy_stock) }
        }.to change(Transaction, :count).by(1)

        expect(response.body).to include("Buy successful!")
      end
    end

    context "with invalid params" do
      it "does not create a new transaction" do
        sign_in user
        expect {
          post transactions_path, params: { transaction: transaction_params(:invalid_buy_stock) }
        }.to change(Transaction, :count).by(0)

        expect(response.body).to include("Transaction Failed!")
      end
    end
  end
end
