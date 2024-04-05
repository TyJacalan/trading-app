class Admin::UsersController < AdminsController
  before_action :set_user, only: [:show, :update, :destroy]

  def reserve
    users_ids = fetch_users_ids
    pending_ids = fetch_pending_ids
    approved_ids = fetch_approved_ids
    admins_ids = fetch_admins_ids
    standards_ids = fetch_standards_ids
  end

  def index
    @user = User.new

    case params[:filter]
    when 'pending'
      @users = User.pending.order(first_name: :desc)
    when 'approved'
      @users = User.approved.order(first_name: :desc)
    when 'admins'
      @users = User.admins.order(first_name: :desc)
    when 'standards'
      @users = User.standards.order(first_name: :desc)
    else
      @users = User.order(first_name: :desc)
    end
  end

  def show; end

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

  def fetch_users_ids
    Rails.cache.fetch("users_ids", expires_in: 5.minutes) do
      User.order(first_name: :desc).pluck(:id)
    end
  end

  def fetch_pending_ids
    Rails.cache.fetch("pending_ids", expires_in: 5.minutes) do
      User.pending.pluck(:id)
    end
  end

  def fetch_approved_ids
    Rails.cache.fetch("approved_ids", expires_in: 5.minutes) do
      User.approved.pluck(:id)
    end
  end

  def fetch_admins_ids
    Rails.cache.fetch("admins_ids", expires_in: 5.minutes) do
      User.admins.pluck(:id)
    end
  end

  def fetch_standards_ids
    Rails.cache.fetch("standards_ids", expires_in: 5.minutes) do
      User.standards.pluck(:id)
    end
  end

  def invalidate_cache
    Rails.cache.delete("pending_ids")
    Rails.cache.delete("approved_ids")
    Rails.cache.delete("admins_ids")
    Rails.cache.delete("standards_ids")
  end
end
