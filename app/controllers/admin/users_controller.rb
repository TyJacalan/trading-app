class Admin::UsersController < AdminsController
  def index
    @users = User.all
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end
end
