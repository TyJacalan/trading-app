# frozen_string_literal: true

module TransactionsConcern # rubocop:disable Style/Documentation
  extend ActiveSupport::Concern

  included do
    def stock_available_balance(symbol, user_id)
      buy_balance = Transaction.where(symbol:, transaction_type: :buy, user_id:).sum(:quantity)
      sell_balance = Transaction.where(symbol:, transaction_type: :sell, user_id:).sum(:quantity)
      buy_balance - sell_balance
    end

    def aggregate_balance_by_symbol(user_id)
      buy_balances = Transaction.where(user_id:, transaction_type: :buy).group(:symbol).sum(:quantity)
      sell_balances = Transaction.where(user_id:, transaction_type: :sell).group(:symbol).sum(:quantity)

      aggregated_balances = {}

      buy_balances.each do |symbol, buy_balance|
        sell_balance = sell_balances[symbol] || 0
        aggregated_balances[symbol] = buy_balance - sell_balance
      end

      aggregated_balances
    end

    def stock_price_average(symbol, user_id)
      total_weighted_price = Transaction.where(symbol:, user_id:).sum(':price * quantity')
      total_count = Transaction.where(symbol:, user_id:).count

      total_count.zero? ? 0 : total_weighted_price.to_f / total_count
    end
  end
end
