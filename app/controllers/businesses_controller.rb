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
    # Check optimistic locking if record_updated_at is provided (inline editing)
    if params[:record_updated_at].present?
      record_updated_at = Time.parse(params[:record_updated_at])
      record_updated_at_sec = record_updated_at.change(usec: 0)
      business_updated_at_sec = @business.updated_at.change(usec: 0)

      if business_updated_at_sec > record_updated_at_sec
        respond_to do |format|
          format.json do
            render json: {
              success: false,
              conflict: true,
              error: 'This record was modified by another user. Please refresh the page.'
            }, status: :conflict
          end
          format.html do
            redirect_to businesses_path, alert: 'This record was modified by another user. Please refresh the page.'
          end
        end
        return
      end
    end

    if @business.update(business_params)
      respond_to do |format|
        format.json do
          render json: {
            success: true,
            data: {
              id: @business.id,
              name: @business.name,
              address: @business.address,
              phone_number: @business.phone_number,
              vat_number: @business.vat_number,
              registration_number: @business.registration_number,
              owner_first_name: @business.owner_first_name,
              owner_last_name: @business.owner_last_name,
              currency: @business.currency,
              updated_at: @business.updated_at.iso8601
            }
          }, status: :ok
        end
        format.html do
          redirect_to businesses_path, notice: t('businesses.messages.updated', name: @business.name)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            success: false,
            errors: @business.errors.full_messages
          }, status: :unprocessable_entity
        end
        format.html do
          set_error_message
          render :show, status: :unprocessable_entity
        end
      end
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
