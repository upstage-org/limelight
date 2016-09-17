class ApplicationMailer < ActionMailer::Base
  default from: ENV['UPSTAGE_NO_REPLY']
  layout 'mailer'
end
