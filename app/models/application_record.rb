class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.search(query)
    return all if query.blank?

    where(
      searchable_columns.map { |col| "#{col}::text ILIKE :query" }.join(' OR '),
      query: "%#{query}%"
    )
  end

  # Dinamički generiše listu kolona koje se pretražuju
  def self.searchable_columns
    column_names - %w[created_at updated_at]
  end
end
