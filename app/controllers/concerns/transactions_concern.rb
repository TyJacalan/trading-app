# frozen_string_literal: true

module TransactionsConcern # rubocop:disable Style/Documentation
  extend ActiveSupport::Concern

  included do

    # def stock_available_balance(symbol, user_id)
    #   buy_balance = Transaction.buy_by_symbol(symbol, user_id).sum(:quantity)
    #   sell_balance = Transaction.sell_by_symbol(symbol, user_id).sum(:quantity)
    #   buy_balance - sell_balance
    # end

    # def aggregate_stocks_by_symbol(user_id)
    #   buy_transactions = Transaction.buy(user_id).group(:symbol).sum(:quantity)
    #   sell_transactions = Transaction.sell(user_id).group(:symbol).sum(:quantity)

    #   aggregated_stocks = []

    #   buy_transactions.each do |symbol, quantity|
    #     sales = sell_transactions[symbol] || 0
    #     stock = @client.quote(symbol)
    #     aggregated_stocks << {
    #       symbol: symbol,
    #       name: stock.company_name,
    #       change: stock.change_percent_s,
    #       quantity: quantity - sales,
    #       price_average: stock_price_average(symbol, user_id),
    #       day_gain: calculate_day_gain(stock.latest_price, quantity, symbol, user_id),
    #       value: stock.latest_price * quantity
    #     }
    #   end

    #   aggregated_stocks
    # end

    # def stock_price_average(symbol, user_id)
    #   total_weighted_price = Transaction.by_symbol(symbol, user_id).sum('price * quantity')
    #   total_count = Transaction.by_symbol(symbol, user_id).count

    #   total_count.zero? ? 0 : total_weighted_price.to_d / total_count
    # end

    # def calculate_day_gain(latest_price, quantity, symbol, user_id)
    #   (latest_price - stock_price_average(symbol, user_id)) * quantity
    # end
  end
end
