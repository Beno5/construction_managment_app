class SubTaskPlanningCalculator

  def initialize(sub_task)
    @sub_task = sub_task
    @norms = sub_task.pinned_norms
    @working_hours_per_day = sub_task.task.project.business.working_hours_per_day
  end

  def call(norms = false)
    if @norms.empty? || @sub_task.quantity.blank?
      return @sub_task.update(
        duration: 0.to_d,
        num_workers_skilled: 0.to_d,
        num_workers_unskilled: 0.to_d,
        num_machines: 0.to_d
      )
    end

    if (duration_changed? && !norms) || dates_changed?
      reverse_calculate_from_duration
    else
      forward_calculate_duration
    end
  end

  private

  def forward_calculate_duration
    num_skilled   = resolve_count(@sub_task.num_workers_skilled, :skilled)
    num_unskilled = resolve_count(@sub_task.num_workers_unskilled, :unskilled)
    num_machines  = resolve_count(@sub_task.num_machines, :machine)

    # Ako niko ne radi, prekini
    return if num_skilled.zero? && num_unskilled.zero? && num_machines.zero?

    # Izračun učinka po satu po tipu
    kv_output_per_hour       = num_skilled / avg_norm(:skilled)
    nkv_output_per_hour      = num_unskilled / avg_norm(:unskilled)
    machine_output_per_hour  = num_machines / avg_norm(:machine)

    # Ukupni output po satu (jedinica/sat)
    total_units_per_hour = kv_output_per_hour + nkv_output_per_hour + machine_output_per_hour
    return if total_units_per_hour.zero?

    # Output po danu
    total_units_per_day = total_units_per_hour * @working_hours_per_day

    # Trajanje = količina / output po danu
    duration = (@sub_task.quantity.to_d / total_units_per_day).round(2)

    @sub_task.update(
      duration: duration,
      num_workers_skilled: num_skilled,
      num_workers_unskilled: num_unskilled,
      num_machines: num_machines
    )

    update_dates_from_duration(duration)
  end

  def reverse_calculate_from_duration
    calculate_total_norm_hours
    update_duration_from_date_changes if dates_changed?

    old_duration = @sub_task.duration_before_last_save
    new_duration = @sub_task.duration
    return if new_duration.zero? || old_duration.zero?

    ratio = old_duration / new_duration

    num_skilled   = @sub_task.num_workers_skilled
    num_unskilled = @sub_task.num_workers_unskilled
    num_machines  = @sub_task.num_machines

    @sub_task.update(
      num_workers_skilled: (num_skilled * ratio).round(2),
      num_workers_unskilled: (num_unskilled * ratio).round(2),
      num_machines: (num_machines * ratio).round(2)
    )

    update_dates_from_duration(new_duration)
  end

  def update_duration_from_date_changes
    return unless @sub_task.planned_start_date.present? && @sub_task.planned_end_date.present?

    new_duration = (@sub_task.planned_end_date - @sub_task.planned_start_date).to_i + 1
    @sub_task.update(duration: new_duration.to_d)
  end

  def update_dates_from_duration(new_duration)
    if @sub_task.planned_start_date.present?
      @sub_task.update(
        planned_end_date: @sub_task.planned_start_date + (new_duration.to_i - 1)
      )
    elsif @sub_task.planned_end_date.present?
      @sub_task.update(
        planned_start_date: @sub_task.planned_end_date - (new_duration.to_i - 1)
      )
    end
  end

  def duration_changed?
    @sub_task.saved_change_to_duration?
  end

  def dates_changed?
    @sub_task.saved_change_to_planned_start_date? || @sub_task.saved_change_to_planned_end_date?
  end

  def resolve_count(value, type)
    return 0.to_d if @norms.none?(&:"#{type}?")

    val = value.present? ? value.to_d : 0.to_d
    val.zero? ? 1.to_d : val
  end

  def avg_norm(type)
    selected = @norms.select(&:"#{type}?")
    return 1.to_d if selected.empty?

    total = selected.sum { |n| n.norm_value.to_d }
    total / selected.size.to_d
  end

  def calculate_total_norm_hours
    @norms.sum { |norm| norm.norm_value * @sub_task.quantity }
  end
end
