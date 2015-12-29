class UserMailer < ApplicationMailer

  default from: 'no-reply@anime-list.ch'
  layout 'mailer'

  def anime_changed_notification_mail(anime, other_user)
    subject = "#{anime.name} has been modified"
  	@anime = anime
    @user = anime.user
    @other_user = other_user
    content_type = "text/html"
  	mail(to: @anime.user.email, subject: subject, content_type: content_type)
  end

end



