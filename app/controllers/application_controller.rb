class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

    def after_sign_in_path_for(resource)
      pages_home_path # Prilagodi sa rutom koju želiš
    end
  
    def after_sign_out_path_for(resource_or_scope)
      root_path # Ili neka druga ruta 
    end

    def after_sign_out_path_for(resource_or_scope)
      new_user_session_path
    end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :terms])
  end
end
