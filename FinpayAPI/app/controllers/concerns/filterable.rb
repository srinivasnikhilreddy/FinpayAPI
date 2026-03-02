module Filterable
  extend ActiveSupport::Concern

  class_methods do # Rails automatically extends ClassMethods into the model. when we include it (using include Filterable). rails internally do Expense.extend(Filterable::ClassMethods) Which makes 'filter_by' a class method => Expense.filter_by(params) works.
    def filter_by(filters)
      results = self # Expense

      filters.slice(*filterable_scopes).each do |key, value| # .slice selects only specified keys
        next if value.blank?

        if key.to_sym == :between_dates
          results = results.public_send(key, filters[:from_date], filters[:to_date]) # public_send: Calls a public method dynamically by name. { by_status: "approved" } => Expense.by_status("approved")
        else
          results = results.public_send(key, value)
        end
      end

      results
    end
  end
end
