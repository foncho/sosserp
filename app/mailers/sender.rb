class Sender < ActionMailer::Base
  def mail_to_provider(data)
    @data = data
    mail to: @data.email,
      from: "lidia@gcnfarma.com",
      suject: @data.subject
  end
end
