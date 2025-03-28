class MaterialsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_business
  before_action :set_material, only: [:show, :edit, :update, :destroy]

  def index
    @materials = current_business.materials.search(params[:search])
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
      redirect_to business_materials_path(@business), notice: 'Material uspješno kreiran'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @material.update(material_params)
      redirect_to business_materials_path(@business), notice: 'Material uspješno ažuriran'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @material = current_business.materials.find(params[:id])
    @material.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(dom_id(@material))
      end
      format.html do
        redirect_to business_materials_path(current_business), notice: "Material was successfully deleted."
      end
    end
  end

  private

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
