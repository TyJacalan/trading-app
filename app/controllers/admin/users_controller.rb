class Admin::UsersController < AdminsController
  before_action :set_user, only: [:show, :update, :destroy]
  include UserCacheManagement

  def index
    @user = User.new
    @users = case params[:filter]
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
  end

  def show
    add_breadcrumb "Home", :admins_path
    add_breadcrumb "Users", :admin_users_path

    transactions = @user.transactions.order(created_at: :desc).page(params[:page]).per(5)

    @transactions = case params[:transaction_type]
                    when 'buy'
                      transactions.buys
                    when 'sell'
                      transactions.sells
                    else
                      transactions
                    end
  end

  def create
    @user = User.build(user_params)

    if @user.save
      invalidate_cache
      redirect_to admin_users_path, notice: "#{@user.first_name}'s account was successfully created."
    else
      redirect_to '/500'
    end
  end

  def update
    if @user.update(user_params)
      invalidate_cache
      redirect_to admin_user_path(@user), notice: "#{@user.first_name}'s account was successfully edited."
    else
      redirect_to '/500'
    end

  end

  def destroy
    @user.destroy
    invalidate_cache
    redirect_to admin_users_path, alert: "#{@user.first_name}'s account was successfully deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
