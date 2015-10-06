class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.anime_changed.subject
  #

  def anime_changed(anime)
  	@anime = anime

  	mail to: "jh@oxon.ch", subject: '#{anime.name} has been modified'
  end


end



