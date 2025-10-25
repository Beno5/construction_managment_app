class BusinessesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_business, only: [:show, :update, :destroy]
  skip_before_action :set_current_business, only: [:select]

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
    @business.user_id = current_user.id

    if @business.save
      redirect_to businesses_path, notice: t('businesses.messages.created', name: @business.name)
    else
      flash.now[:alert] = t('workers.messages.first_name_required')
      render :show, status: :unprocessable_entity
    end
  end

  def update
    if @business.update(business_params)
      redirect_to businesses_path, notice: t('businesses.messages.updated', name: @business.name)
    else
      flash.now[:alert] = t('businesses.messages.name_required')
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    name = @business.name
    @business.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("row_#{@business.id}")
      end
      format.html { redirect_to businesses_path, notice: t('businesses.messages.deleted', name: name) }
    end
  end

  def select
    business = current_user.businesses.find_by(id: params[:id])
    if business
      session[:current_business_id] = business.id
      redirect_to root_path, notice: t("businesses.messages.selected", name: business.name)
    else
      redirect_to businesses_path, alert: t('businesses.messages.not_found')
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
