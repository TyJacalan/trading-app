class PostMailer < ApplicationMailer

  def approved_user_email(user)
    @user = user
    @body = "Your account has been approved. You may now "

    mail(
      to: @user.email,
      subject: "Your account has been approved!",
      from: configure_from_address)
  end

  private

  def configure_from_address
    if Rails.env.development?
      "hello@avionfinance.com"
    else
      email_address = Rails.application.credentials.dig(:GOOGLE_SMTP_EMAIL)
      email_address.present? ? "Avion Finance <#{email_address}>" : "Avion Finance <tyjacalan@gmail.com>"
    end
  end
end
