class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end

  private

  def authorize_user!
    redirect_to '/admins' unless current_user.standard?
  end

  def authorize_admin!
    redirect_to '/422' unless current_user.admin?
  end

  public

  def set_stock_api
    @client = IEX::Api::Client.new(
      publishable_token: IEX::Api.config.publishable_token,
      secret_token: IEX::Api.config.secret_token,
      endpoint: IEX::Api.config.endpoint
    )
  end

end
