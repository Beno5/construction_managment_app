# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, except: [:new, :create, :destroy]
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /users/sign_up
  def new
    super
  end

  # GET /users/edit
  def edit
    super
  end

  # POST /users
  def create
    build_resource(sign_up_params)

    if resource.save
      set_flash_message!(:notice, :signed_up)
      sign_in(resource_name, resource)
      redirect_to after_sign_in_path_for(resource)
    else
      # ⚠️ Prikaz validacijskih grešaka (email postoji, lozinke se ne poklapaju, itd.)
      flash.now[:alert] = resource.errors.map(&:message).join(', ')
      clean_up_passwords(resource)
      render :new, status: :unprocessable_entity
    end
  end

  # PUT /users
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update(account_update_params)
      # osvježi sesiju i prijavu bez ponovnog login-a
      bypass_sign_in resource, scope: resource_name

      # odmah koristi novi jezik koji je user postavio
      I18n.locale = resource.locale || I18n.default_locale
      session[:locale] = I18n.locale

      redirect_to edit_user_registration_path(locale: I18n.locale),
                  notice: t('users.messages.updated', default: 'Profile successfully updated.')
    else
      flash.now[:alert] = resource.errors.full_messages.join(', ')
      render :edit, status: :unprocessable_entity, locals: { locale: params[:locale] }
    end
  end

  # DELETE /users
  def destroy
    resource.destroy

    # ✅ Odjava nakon brisanja korisnika
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    # ✅ Lokalizovana poruka
    flash[:notice] = t('devise.registrations.destroyed', default: 'Your account has been successfully deleted.')

    # ✅ Preusmjeri na login umjesto na root
    redirect_to new_user_session_path(locale: I18n.locale)
  end

  protected

  # 👤 Dozvoli atribute pri registraciji
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
                                        :email,
                                        :password,
                                        :password_confirmation,
                                        :terms,
                                        :locale
                                      ])
  end

  # 🛠️ Dozvoli atribute pri ažuriranju profila
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
                                        :name,
                                        :email,
                                        :locale,
                                        :password,
                                        :password_confirmation
                                      ])
  end

  # 🚪 Nakon prijave — vodi korisnika na svoj business dashboard
  def after_sign_in_path_for(resource)
    businesses_path(locale: resource.locale || I18n.default_locale)
  end
end
