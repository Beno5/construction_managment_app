# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  before_action :configure_account_update_params, only: [:update]

  # GET /users/edit
  def edit
    super
  end

  # PUT /users
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update(account_update_params)
      bypass_sign_in resource, scope: resource_name
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
    flash[:notice] = t('devise.registrations.destroyed', default: 'Your account has been deleted.')
    redirect_to root_path(locale: I18n.locale)
  end

  protected

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :locale, :password])
  end
end
