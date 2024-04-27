require "rails_helper"

RSpec.describe PostMailer, type: :mailer do
  describe "approved_user_email" do
    let(:user) { users(:valid_user) }
    let(:mail) { PostMailer.approved_user_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Your account has been approved!")
      expect(mail.to).to eq([user.email])
      #expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Your account has been approved.")
    end
  end

end
