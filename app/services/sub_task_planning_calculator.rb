class SubTaskPlanningCalculator
  DEFAULT_BPRSPD = 9.0

  def initialize(sub_task)
    @sub_task = sub_task
    @norms = sub_task.pinned_norms
  end

  def call(norms = false)
    return @sub_task.update(duration: 0, num_workers_skilled: 0,
                    num_workers_unskilled: 0, num_machines: 0) if @norms.empty? || @sub_task.quantity.blank?

    if duration_changed? && !norms
      reverse_calculate_from_duration
    else
      forward_calculate_duration
    end
  end

  private

  def forward_calculate_duration
    total_norm_hours = calculate_total_norm_hours
    return if total_norm_hours.zero?

   num_skilled   = resolve_count(@sub_task.num_workers_skilled, :skilled)
   num_unskilled = resolve_count(@sub_task.num_workers_unskilled, :unskilled)
   num_machines  = resolve_count(@sub_task.num_machines, :machine)



    total_active_units = num_skilled + num_unskilled + num_machines
    return if total_active_units.zero?

    effective_hours_per_day = total_active_units * DEFAULT_BPRSPD
    duration = (total_norm_hours / effective_hours_per_day).round(2)

    @sub_task.update(duration: duration, num_workers_skilled: num_skilled,
                    num_workers_unskilled: num_unskilled, num_machines: num_machines)
  end

  def reverse_calculate_from_duration
    total_norm_hours = calculate_total_norm_hours
    old_duration = @sub_task.duration_before_last_save.to_f
    new_duration = @sub_task.duration.to_f
    return if new_duration.zero? || old_duration.zero?

    ratio = old_duration / new_duration

    num_skilled   = @sub_task.num_workers_skilled.to_f
    num_unskilled = @sub_task.num_workers_unskilled.to_f
    num_machines  = @sub_task.num_machines.to_f

    @sub_task.update(
      num_workers_skilled:   (num_skilled * ratio).round(2),
      num_workers_unskilled: (num_unskilled * ratio).round(2),
      num_machines:          (num_machines * ratio).round(2)
    )
  end

  def duration_changed?
    @sub_task.saved_change_to_duration?
  end

  def resolve_count(value, type)
    value.to_f.zero? && @norms.any?(&:"#{type}?") ? 1 : value.to_f
  end


  def default_count(type)
    case type
    when :skilled
      @norms.any?(&:skilled?) ? 1 : 0
    when :unskilled
      @norms.any?(&:unskilled?) ? 1 : 0
    when :machine
      @norms.any?(&:machine?) ? 1 : 0
    else
      0
    end
  end

  def calculate_total_norm_hours
    @norms.sum { |norm| norm.norm_value.to_f * @sub_task.quantity.to_f }
  end
end
