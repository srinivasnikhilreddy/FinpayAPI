require 'apartment/elevators/generic'

Apartment.configure do |config|
  config.excluded_models = %w[
    Company
    PlatformUser
  ]

  config.use_schemas = true

  config.tenant_names = -> { Company.pluck(:subdomain) }
end

Rails.application.config.middleware.use Apartment::Elevators::Generic, lambda { |request|
  company_id = request.get_header('HTTP_X_COMPANY_ID')
  Company.exists?(subdomain: company_id) ? company_id : nil
}