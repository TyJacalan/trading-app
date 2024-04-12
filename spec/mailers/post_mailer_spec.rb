require "rails_helper"

RSpec.describe PostMailer, type: :mailer do
  describe "approved_user_email" do
    let(:mail) { PostMailer.approved_user_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Approved user email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
