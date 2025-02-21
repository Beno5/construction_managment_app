class FetchDataController < ApplicationController
  def unit_options
    render json: {
      worker: Worker.unit_of_measures.keys.map { |k| [k.humanize, k] }.to_h,
      material: Material.unit_of_measures.keys.map { |k| [k.humanize, k] }.to_h,
      machine: Machine.unit_of_measures.keys.map { |k| [k.humanize, k] }.to_h
    }
  end
end
