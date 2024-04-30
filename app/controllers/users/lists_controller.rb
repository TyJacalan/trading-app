class Users::ListsController < AdminsController
  def show
    filter = params[:filter]
    users = case filter
             when 'pending'
               fetch_users(User.pending)
             when 'approved'
               fetch_users(User.approved)
             when 'admins'
               fetch_users(User.admins)
             when 'standards'
               fetch_users(User.standards)
             else
               fetch_users(User.all)
             end

    @user = User.new
    @users = Kaminari.paginate_array(users).page(params[:page]).per(10)
  end
end
