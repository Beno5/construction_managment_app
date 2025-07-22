class NormsController < ApplicationController
  before_action :set_norm, only: [:edit, :update, :destroy]

  def index
    @searched_norms = Norm.search(params[:search])

    if params[:sub_task_id].present?
      @sub_task = SubTask.find(params[:sub_task_id])
      @pinned_norms = @sub_task.pinned_norms
      # kombinuj i izbaci duplikate
      @norms = (@pinned_norms + @searched_norms).uniq
      # sortiraj tako da pinned norme budu prve
      @norms.sort_by! { |n| @pinned_norms.include?(n) ? 0 : 1 }
    else
      @sub_task = nil
      @pinned_norms = []
      @norms = @searched_norms
    end

    respond_to do |format|
      format.html do
        if turbo_frame_request?
          render partial: "partials/table_norms", locals: {
            norms: @norms,
            sub_task: @sub_task,
            pinned_norms: @pinned_norms
          }
        end
      end
    end
  end

  def new
    @norm = Norm.new
  end

  def edit; end

  def create
    @norm = Norm.new(norm_params)
    if @norm.save
      redirect_to business_norms_path(@business), notice: "Norma uspješno kreirana."
    else
      render :new
    end
  end

  def update
    if @norm.update(norm_params)
      redirect_to business_norms_path(@business), notice: "Norma uspješno ažurirana."
    else
      render :edit
    end
  end

  def destroy
    @norm.destroy
    redirect_to business_norms_path(@business), notice: "Norma obrisana."
  end

  private

  def set_business
    @business = Business.find(params[:business_id])
  end

  def set_norm
    @norm = Norm.find(params[:id])
  end

  def norm_params
    params.require(:norm).permit(:name, :description, :info, :norm_type, :subtype, :unit_of_measure, :norm_value,
                                 tags: [])
  end
end
