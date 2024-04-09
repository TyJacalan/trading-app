module AdminConcern
  extend ActiveSupport::Concern
    included do
      after_action :notify_user, only: [:update]
    end

    private

    def notify_user
      if @user.persisted?
        PostMailer.approved_user_email(@user).deliver_later
      end
    end
end
