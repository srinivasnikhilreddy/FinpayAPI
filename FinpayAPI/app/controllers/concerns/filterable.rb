# app/models/concerns/filterable.rb

module Filterable
  extend ActiveSupport::Concern

  class_methods do # Rails automatically extends ClassMethods into the model. when we include it (using include Filterable). rails internally do Expense.extend(Filterable::ClassMethods) Which makes 'filter_by' a class method => Expense.filter_by(params) works.
    def filter_by(filters)
      results = self

      filters.slice(*filterable_scopes).each do |key, value| # .slice selects only specified keys
        next if value.blank?

        if value.is_a?(Array)
          results = results.public_send(key, *value)
        else
          results = results.public_send(key, value)
        end
      end

      results
    end
  end
end
