class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :edit, :update, :destroy]

  skip_before_action :set_current_business, only: [:select]

  def index
    @businesses = current_user.businesses
    # Breadcrumbs automatski dodaje "Businesses"
  end

  def new
    @business = current_user.businesses.new
    # Breadcrumbs automatski dodaje "Businesses → New Business"
  end

  def edit
    # Breadcrumbs automatski dodaje "Businesses → Edit Business"
  end

  def create
    @business = current_user.businesses.new(business_params)
    if @business.save
      redirect_to businesses_path, notice: 'Business created successfully.'
    else
      render :new
    end
  end

  def update
    if @business.update(business_params)
      redirect_to businesses_path, notice: 'Business updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @business.destroy
    redirect_to businesses_path, notice: 'Business deleted successfully.'
  end

  def select
    business = current_user.businesses.find(params[:id])
    if business
      session[:current_business_id] = business.id
      redirect_to root_path, notice: "#{business.name} is now selected."
    else
      redirect_to businesses_path, alert: "Business not found."
    end
  end

  private

  def set_business
    @business = current_user.businesses.find(params[:id])
    # Breadcrumbs automatski dodaje "Test Business" kada je postavljen @business
  end

  def business_params
    params.require(:business).permit(:name, :address, :phone_number)
  end
end
