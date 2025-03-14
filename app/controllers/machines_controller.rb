class MachinesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_business
  before_action :set_machine, only: [:show, :edit, :update, :destroy]

  def index
    @machines = current_business.machines.search(params[:search])
    respond_to do |format|
      format.html # Renderuje standardni HTML za klasične prelaze
      format.turbo_stream # Renderuje Turbo Stream za pretragu
    end
  end

  def show; end

  def new
    @machine = @business.machines.new
  end

  def edit; end

  def create
    @machine = @business.machines.new(machine_params)
    @machine = current_user.id

    if @machine.save
      redirect_to business_machines_path(@business), notice: 'Machine was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @machine.update(machine_params)
      redirect_to business_machines_path(@business), notice: 'Machine was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @machine = current_business.machines.find(params[:id])
    @machine.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(dom_id(@machine))
      end
      format.html { redirect_to business_machines_path(current_business), notice: "Machine was successfully deleted." }
    end
  end

  private

  def set_machine
    @machine = @business.machines.find(params[:id])
  end

  def machine_params
    params.require(:machine).permit(
      :name, :unit_of_measure, :price_per_unit, :fixed_costs, :description,
      custom_fields: [:key, :value]
    ).tap do |whitelisted|
      if params[:machine][:custom_fields]
        transformed_custom_fields = params[:machine][:custom_fields].to_unsafe_h.each_with_object({}) do |(_, field), hash|
          hash[field["key"]] = field["value"] if field["key"].present? && field["value"].present?
        end
        whitelisted[:custom_fields] = transformed_custom_fields
      else
        whitelisted[:custom_fields] = {}
      end
    end
  end
end
