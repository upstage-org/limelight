class SubscriptionsMailer < ApplicationMailer
  def make_announcement(announcement, user)
    subj = announcement.title
    subj = "[UPDATED] #{subj}" if announcement.updated_at > announcement.created_at
    @announcement = announcement
    mail( to: user.email, subject: subj )
  end
end
