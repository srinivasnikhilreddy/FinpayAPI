require 'apartment/elevators/generic'

Apartment.configure do |config|
  # Excluded models always stay in public schema.
  config.excluded_models = %w[
    Company
    PlatformUser
  ]

  config.use_schemas = true

  config.tenant_names = lambda {
    Company.where.not(subdomain: nil).pluck(:subdomain)
  }
end

Rails.application.config.middleware.use Apartment::Elevators::Generic, lambda { |request|
  company_id = request.get_header('HTTP_X_COMPANY_ID')
  return nil unless company_id.present?

  company = Company.find_by(subdomain: company_id)
  return nil unless company

  company.subdomain
}