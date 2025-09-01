class BusinessesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_business, only: [:edit, :update, :destroy]
  skip_before_action :set_current_business, only: [:select]

  def index
    @businesses = current_user.businesses.search(params[:search])

    respond_to do |format|
      format.html # Renderuje standardni HTML za klasične prelaze
      format.turbo_stream # Renderuje Turbo Stream za pretragu
    end
  end

  def new
    @business = current_user.businesses.new
  end

  def edit
    @business = current_user.businesses.find_by(id: params[:id])
    return if @business

    redirect_to businesses_path, alert: "Business not found."
  end

  def create
    @business = current_user.businesses.new(business_params)
    @business.user_id = current_user.id

    if @business.save
      redirect_to businesses_path, notice: "Business created successfully."
    else
      # Provjeri specifično za name error
      if @business.errors[:name].any?
        redirect_to new_business_path, alert: "Name is required!"
      else
        # Ostali validation errori
        error_messages = @business.errors.full_messages.join(", ")
        redirect_to new_business_path, alert: error_messages
      end
    end
  end

  def update
    if @business.update(business_params)
      redirect_to businesses_path, notice: "Business updated successfully."
    else
      # Isto i za update
      if @business.errors[:name].any?
        redirect_to edit_business_path(@business), alert: "Name is required!"
      else
        error_messages = @business.errors.full_messages.join(", ")
        redirect_to edit_business_path(@business), alert: error_messages
      end
    end
  end

  def destroy
    @business.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("row_#{@business.id}")
      end
      format.html { redirect_to businesses_path, notice: "Business deleted successfully." }
    end
  end

  def select
    business = current_user.businesses.find_by(id: params[:id])
    if business
      session[:current_business_id] = business.id
      redirect_to root_path, notice: "#{business.name} is now selected."
    else
      redirect_to businesses_path, alert: "Business not found."
    end
  end

  private

  def business_params
    params.require(:business).permit(:name, :address, :phone_number, :vat_number, :registration_number,
                                     :owner_first_name, :owner_last_name, :currency)
  end

  def set_business
    @business = current_user.businesses.find(params[:id])
  end
end