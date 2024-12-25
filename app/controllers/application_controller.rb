class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_business, if: :user_signed_in?
  before_action :set_breadcrumbs
  helper_method :current_business

  

  # Redirect paths after sign in/out
  def after_sign_in_path_for(resource)
    root_path # Prilagodite po potrebi
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path # Prilagodite po potrebi
  end
  

  private

  def current_business
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

  # Postavljanje breadcrumbs-a
  def set_breadcrumbs
    @breadcrumbs = []
  
    # Dodaj trenutni business uvek na prvo mesto
    @breadcrumbs << { name: current_business.name, path: business_path(current_business) } if current_business

    # Dodaj dinamične nivoe na osnovu kontrolera i akcije
    case controller_name
    when "projects"
      if action_name == "index"
        @breadcrumbs << { name: "Projects", path: business_projects_path(current_business) }
      elsif action_name == "show"
        set_project
        @breadcrumbs << { name: @project.name, path: business_project_path(current_business, @project) }
      elsif action_name == "new"
        @breadcrumbs << { name: "New Project", path: nil }
      elsif action_name == "edit"
        @breadcrumbs << { name: "Edit Project", path: nil }
      end
    when "tasks"
      if action_name == "index"
        @breadcrumbs << { name: "Tasks", path: business_project_tasks_path(current_business, @project) }
      elsif action_name == "new"
        @breadcrumbs << { name: "New Task", path: nil }
      elsif action_name == "edit"
        @breadcrumbs << { name: "Edit Task", path: nil }
      end
    end
  end

  # Breadcrumbs za Projects
  def set_project_breadcrumbs
    set_current_business
    if @current_business.nil?
      redirect_to businesses_path, alert: "Please select a business to view projects."
      return
    end
  
    if action_name == "index"
      @breadcrumbs << { name: "Projects", path: business_projects_path(@current_business) }
    elsif action_name == "new"
      @breadcrumbs << { name: "New Project", path: nil }
    elsif action_name == "edit"
      @breadcrumbs << { name: "Edit Project", path: nil }
    end
  end  

  # Breadcrumbs za Tasks
  def set_task_breadcrumbs
    if action_name == "index"
      @breadcrumbs << { name: "Tasks", path: business_project_tasks_path(@current_business, @project) }
    elsif action_name == "new"
      @breadcrumbs << { name: "New Task", path: nil }
    elsif action_name == "edit"
      @breadcrumbs << { name: "Edit Task", path: nil }
    end
  end

  # Breadcrumbs za Workers
  def set_worker_breadcrumbs
    if action_name == "index"
      @breadcrumbs << { name: "Workers", path: business_workers_path(@current_business) }
    elsif action_name == "new"
      @breadcrumbs << { name: "New Worker", path: nil }
    elsif action_name == "edit"
      @breadcrumbs << { name: "Edit Worker", path: nil }
    end
  end

  protected

  # Dodatne parametre za Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :terms])
  end
end
