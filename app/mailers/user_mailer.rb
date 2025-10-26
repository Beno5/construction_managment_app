class UserMailer < ApplicationMailer
  default from: 'no-reply@conormio.com'

  def welcome_email(user)
    @user = user
    @url  = new_user_session_url

    I18n.with_locale(@user.locale || I18n.default_locale) do
      mail(
        to: @user.email,
        subject: I18n.t('user_mailer.welcome_email.subject')
      )
    end
  end
end
