class Admin::UsersController < AdminsController
  before_action :set_user, only: [:show, :update, :destroy]
  def index
    @users = User.order(first_name: :desc)
    @user = User.new
  end

  def show
  end

  def create
    @user = User.build(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "#{@user.first_name}'s account was successfully created."
    else
      redirect_to '/500'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "#{@user.first_name}'s account was successfully edited."
    else
      redirect_to '/500'
    end

  end

  def destroy
    @user.destroy

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
