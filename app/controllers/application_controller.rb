class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_business, if: :user_signed_in?
  helper_method :current_business

  # Redirekcija nakon uspješne prijave
  def after_sign_in_path_for(resource)
    businesses_path
  end

  # Centralizovani metod za postavljanje poslovanja
  def set_business
    @business = current_user.businesses.find_by(id: params[:business_id])
    redirect_to businesses_path, alert: "Business not found." unless @business
  end
  
  private

  def current_business
    return nil unless user_signed_in?

    @current_business ||= current_user.businesses.find_by(id: session[:current_business_id])
  end

  def set_current_business
    
    if params[:business_id].present?
      @current_business = current_user.businesses.find_by(id: params[:business_id])
      session[:current_business_id] = @current_business.id if @current_business
    elsif session[:current_business_id]
      @current_business = current_user.businesses.find_by(id: session[:current_business_id])
    else
      @current_business = current_user.businesses.first
      session[:current_business_id] = @current_business.id if @current_business
    end
  end

  # Devise dodatna konfiguracija
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :terms])
  end
end
