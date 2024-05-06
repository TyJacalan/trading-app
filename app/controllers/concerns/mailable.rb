module Mailable
  extend ActiveSupport::Concern
    private

    def notify_user(method)
      if @user.persisted?
        PostMailer.send(method, @user).deliver_later
      end
    end
end
