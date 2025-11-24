class MaterialsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :require_business
  before_action :set_business
  before_action :set_material, only: [:show, :edit, :update, :destroy]

  def index
    @materials = current_business.materials.search(params[:search]).page(params[:material_page]).per(10)

    respond_to do |format|
      format.html # Renderuje standardni HTML za klasične prelaze
      format.turbo_stream # Renderuje Turbo Stream za pretragu
    end
  end

  def show; end

  def new
    @material = @business.materials.new
  end

  def edit; end

  def create
    @material = @business.materials.new(material_params)
    @material.user_id = current_user.id

    if @material.save
      redirect_to business_materials_path(@business),
                  notice: t("materials.messages.created", name: @material.name)
    else
      flash.now[:alert] = t('materials.messages.name_required')
      render :show, status: :unprocessable_entity
    end
  end

  def update
    if @material.update(material_params)
      redirect_to business_materials_path(@business),
                  notice: t("materials.messages.updated", name: @material.name)
    else
      flash.now[:alert] = t('materials.messages.name_required')
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    name = @material.name
    @material.destroy

    respond_to do |format|
      format.turbo_stream # koristi destroy.turbo_stream.erb
      format.html do
        redirect_to business_materials_path(current_business),
                    notice: t("materials.messages.deleted", name: name)
      end
    end
  end

  private

  def set_business
    @business = current_user.businesses.find(params[:business_id])
    @current_business = @business  # For backward compatibility with views
  end

  def set_material
    @material = @business.materials.find(params[:id])
  end

  def material_params
    params.require(:material).permit(
      :name, :price_per_unit, :unit_of_measure, :description,
      custom_fields: [:key, :value]
    ).tap do |whitelisted|
      if params[:material][:custom_fields]
        transformed_custom_fields = params[:material][:custom_fields].to_unsafe_h.each_with_object({}) do |(_, field), hash|
          hash[field["key"]] = field["value"] if field["key"].present? && field["value"].present?
        end
        whitelisted[:custom_fields] = transformed_custom_fields
      else
        whitelisted[:custom_fields] = {}
      end
    end
  end
end
