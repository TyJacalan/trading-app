class Admin::UsersController < AdminsController
  include Mailable
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @user = User.new
  end

  def show
    add_breadcrumb "Home", :admins_path
    add_breadcrumb "Users", :admin_users_path

    transactions = fetch_transactions

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
    notify_user(:deleted_user_email)
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

  def fetch_transactions
    if params[:transaction_id].present?
      fetch_transactions_by_id
    else
      @user.transactions.order(created_at: :desc).page(params[:page]).per(5)
    end
  end

  def fetch_transactions_by_id
    @user.transactions.where(id: params[:transaction_id]).order(created_at: :desc).page(params[:page]).per(5)
  end
end
