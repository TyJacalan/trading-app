class Users::SearchController < ApplicationController
  def show
    query = params[:query].present? ? params[:query].downcase : ''

    filtered_users = User.all.select { |user| includes_query?(user, query) }
                                .sort_by(&:first_name)
    
    @users = Kaminari.paginate_array(filtered_users).page(params[:page]).per(10)
    @user = User.new

    render turbo_stream: 
      turbo_stream.update('users_table', 
                          partial: 'users/lists/users')
  end

  private

  def includes_query?(user, query)
    user.first_name.downcase.include?(query) || 
      user.last_name.downcase.include?(query) ||
      user.email.downcase.include?(query)
  end
end
