class BusinessesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :load_business, only: [:show, :update, :destroy]

  def index
    @businesses = current_user.businesses.search(params[:search]).page(params[:business_page]).per(10)

    respond_to do |format|
      format.html # Renderuje standardni HTML za klasične prelaze
      format.turbo_stream # Renderuje Turbo Stream za pretragu
    end
  end

  def show; end

  def new
    @business = current_user.businesses.new
  end

  def create
    @business = current_user.businesses.new(business_params)

    if @business.save
      # Auto-select this business (especially important for first business)
      session[:current_business_id] = @business.id
      redirect_to businesses_path, notice: t('businesses.messages.created', name: @business.name)
    else
      set_error_message
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @business.update(business_params)
      redirect_to businesses_path, notice: t('businesses.messages.updated', name: @business.name)
    else
      set_error_message
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    name = @business.name
    was_current = (session[:current_business_id] == @business.id)

    @business.destroy

    # If deleted business was current, clear session and let current_business helper auto-select next one
    if was_current
      session[:current_business_id] = nil
      @was_current_business = true # Used in turbo_stream partial
    end

    respond_to do |format|
      format.turbo_stream # uses destroy.turbo_stream.erb
      format.html { redirect_to businesses_path, notice: t('businesses.messages.deleted', name: name) }
    end
  end

  def select
    @business = current_user.businesses.find(params[:id])
    session[:current_business_id] = @business.id
    redirect_to root_path, notice: t('businesses.messages.selected', name: @business.name)
  end

  private

  def business_params
    params.require(:business).permit(:name, :address, :phone_number, :vat_number, :registration_number,
                                     :owner_first_name, :owner_last_name, :currency, :working_hours_per_day)
  end

  def load_business
    @business = current_user.businesses.find(params[:id])
  end

  def set_error_message
    flash.now[:alert] = if @business.errors[:name].any?
                          @business.errors[:name].first
                        elsif @business.errors[:base].any?
                          @business.errors[:base].first
                        else
                          t('businesses.errors.validation_failed')
                        end
  end
end
