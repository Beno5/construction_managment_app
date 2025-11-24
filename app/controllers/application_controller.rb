class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  helper_method :current_business

  # Redirekcija nakon uspješne prijave
  def after_sign_in_path_for(resource)
    # koristi korisnikov jezik, ako ga ima, inače default (sr)
    businesses_path(locale: resource.locale || :sr)
  end

  # Uvijek dodaj locale u sve URL-ove
  def default_url_options
    { locale: I18n.locale }
  end

  # Postavljanje jezika
  def set_locale
    I18n.locale =
      params[:locale] ||
      (current_user.locale if user_signed_in?) ||
      session[:locale] ||
      :sr

    session[:locale] = I18n.locale
  end

  private

  # Returns the current business for the logged-in user
  # Automatically selects the first business if none is set in session
  def current_business
    return nil unless user_signed_in?

    @current_business ||= begin
      business = current_user.businesses.find_by(id: session[:current_business_id])

      # Auto-select first business if session is empty or invalid
      if business.nil? && current_user.businesses.exists?
        business = current_user.businesses.first
        session[:current_business_id] = business.id
      end

      business
    end
  end

  # Redirects to businesses page if user has no business
  # Use this before_action in controllers that require a business (projects, workers, etc.)
  def require_business
    return if current_business.present?

    redirect_to businesses_path, alert: t('businesses.errors.no_business_selected')
  end

  # Finds and sets @business from params[:business_id] (for nested routes)
  # Raises ActiveRecord::RecordNotFound if business doesn't belong to current_user
  def set_business_from_params
    business_id = params[:business_id] || params[:id]
    @business = current_user.businesses.find(business_id)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
                                        :email,
                                        :password,
                                        :password_confirmation,
                                        :terms
                                      ])
  end
end
