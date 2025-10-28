# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user!, except: [:destroy]

  # GET /users/sign_in
  def new
    super
  end

  # POST /users/sign_in
  def create
    self.resource = warden.authenticate(auth_options)

    if resource
      # ✅ Uspješan login
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      redirect_to after_sign_in_path_for(resource)
    else
      # ❌ Pogrešan email ili lozinka
      flash.now[:alert] = t('devise.failure.invalid', default: 'Invalid email or password.')
      self.resource = resource_class.new(sign_in_params)
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /users/sign_out
  def destroy
    sign_out(resource_name)
    flash[:notice] = t('devise.sessions.signed_out', default: 'You have been successfully signed out.')
    redirect_to new_user_session_path(locale: I18n.locale)
  end

  protected

  def after_sign_in_path_for(resource)
    businesses_path(locale: resource.locale || I18n.default_locale)
  end
end
