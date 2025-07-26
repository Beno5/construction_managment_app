class SubTaskPlanningCalculator
  DEFAULT_BPRSPD = 9.0 # broj radnih sati po danu

  def initialize(sub_task)
    @sub_task = sub_task
    @norms = sub_task.pinned_norms
  end

  def call(norms = false)
    if @norms.empty? || @sub_task.quantity.blank?
      return @sub_task.update(duration: 0, num_workers_skilled: 0,
                              num_workers_unskilled: 0, num_machines: 0)
    end

    if duration_changed? && !norms
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
    kv_output_per_hour  = num_skilled / avg_norm(:skilled)
    nkv_output_per_hour = num_unskilled / avg_norm(:unskilled)
    machine_output_per_hour = num_machines / avg_norm(:machine)

    # Ukupni output po satu (jedinica/sat)
    total_units_per_hour = kv_output_per_hour + nkv_output_per_hour + machine_output_per_hour
    return if total_units_per_hour.zero?

    # Output po danu
    total_units_per_day = total_units_per_hour * DEFAULT_BPRSPD

    # Trajanje = količina / output po danu
    duration = (@sub_task.quantity.to_f / total_units_per_day).round(2)

    @sub_task.update(
      duration: duration,
      num_workers_skilled: num_skilled,
      num_workers_unskilled: num_unskilled,
      num_machines: num_machines
    )
  end

  def reverse_calculate_from_duration
    calculate_total_norm_hours
    old_duration = @sub_task.duration_before_last_save.to_f
    new_duration = @sub_task.duration.to_f
    return if new_duration.zero? || old_duration.zero?

    ratio = old_duration / new_duration

    num_skilled   = @sub_task.num_workers_skilled.to_f
    num_unskilled = @sub_task.num_workers_unskilled.to_f
    num_machines  = @sub_task.num_machines.to_f

    @sub_task.update(
      num_workers_skilled: (num_skilled * ratio).round(2),
      num_workers_unskilled: (num_unskilled * ratio).round(2),
      num_machines: (num_machines * ratio).round(2)
    )
  end

  def duration_changed?
    @sub_task.saved_change_to_duration?
  end

  def resolve_count(value, type)
    value.to_f.zero? && @norms.any?(&:"#{type}?") ? 1 : value.to_f
  end

  def avg_norm(type)
    selected = @norms.select(&:"#{type}?")
    return 1.0 if selected.empty?

    total = selected.sum { |n| n.norm_value.to_f }
    total / selected.size
  end

  def calculate_total_norm_hours
    @norms.sum { |norm| norm.norm_value.to_f * @sub_task.quantity.to_f }
  end
end
