class Transactions::SearchController < ApplicationController
  def show
    query = params[:query].present? ? params[:query].downcase : ''
    user = User.find(params[:user_id])
    transactions = if params[:user_id].present?
                     Transaction.where(user_id: user.id)
                   else
                     Transaction.all
                   end

    filtered_transactions = transactions.select { |transaction| includes_query?(transaction, query) }
                                .sort_by(&:created_at).reverse
    
    @transactions = Kaminari.paginate_array(filtered_transactions).page(params[:page]).per(5)

    render turbo_stream: turbo_stream.update('user_transactions', partial: 'transactions/user_transactions_table')
  end

  private

  def includes_query?(transaction, query)
    transaction.symbol.downcase.include?(query) || 
      transaction.transaction_type.downcase.include?(query)
  end
end
