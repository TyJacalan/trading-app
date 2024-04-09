class PostMailer < ApplicationMailer

  def approved_user_email(user)
    @user = user
    @body = "Your account has been approved. You may now "

    mail(
      to: @user.email,
      subject: "Your account has been approved!")
  end
end
