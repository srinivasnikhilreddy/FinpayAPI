class TenantSwitcher
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    company_id = request.get_header("HTTP_X_COMPANY_ID")

    Rails.logger.info "Header received: #{company_id}"
    Rails.logger.info "Current path: #{request.path}"

    if company_id.present?
      switch_schema(company_id)
    else
      set_public_schema
    end

    @app.call(env)
  ensure
    set_public_schema
  end

  private

  def switch_schema(company_id)
    set_public_schema

    company = Company.find_by(subdomain: company_id)
    raise ActiveRecord::RecordNotFound, "Company not found" unless company

    # STRICT validation — allow only lowercase letters, numbers, underscore
    unless company.subdomain.match?(/\A[a-z0-9_]+\z/)
      raise "Invalid schema name"
    end

    ActiveRecord::Base.connection.schema_search_path = "#{company.subdomain},public"
    Rails.logger.info "Switched to schema: #{company.subdomain}"
  end

  def set_public_schema
    ActiveRecord::Base.connection.schema_search_path = "public"
  end
end

=begin
automatic tenant switching based on subdomain:

install apartment => config/initializers/apartment.rb
Apartment.configure do |config|
  config.excluded_models = %w{ Company } # Exclude the Company model from being multi-tenanted
  config.tenant_names = lambda { Company.pluck(:subdomain) } # Dynamically fetch tenant names from the database
end
Rails.application.config.middleware.use(Apartment::Elevators::Subdomain)

=end