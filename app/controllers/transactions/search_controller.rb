class Transactions::SearchController < ApplicationController
  def show
    query = params[:query].present? ? params[:query].downcase : ''
    
    user = params[:user_id].present? ? User.find(params[:user_id]) : nil
    
    transactions = if user
                     Transaction.where(user_id: user.id)
                   else
                     Transaction
                   end

    filtered_transactions = transactions.select { |transaction| includes_query?(transaction, query) }
                                .sort_by(&:created_at).reverse
    
    @transactions = Kaminari.paginate_array(filtered_transactions).page(params[:page]).per(5)

    render turbo_stream: 
      turbo_stream.update('transactions', partial: turbo_stream_partial(user))
  end

  private

  def includes_query?(transaction, query)
    symbol_matches = transaction.symbol.present? && transaction.symbol.downcase.include?(query)
    type_matches = transaction.transaction_type.present? && transaction.transaction_type.downcase.include?(query)
    symbol_matches || type_matches
  end

  def turbo_stream_partial(user)
    if user
      'transactions/user_transactions_table'
    else
      'admin/transactions/admin_transactions_table'
    end
  end
end
