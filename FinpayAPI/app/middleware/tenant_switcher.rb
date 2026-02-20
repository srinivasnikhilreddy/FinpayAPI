class TenantSwitcher
  def initialize(app)
    @app = app
  end

  def call(env)
    # POST /users
    # Header: X-Company-Id: company1
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
    # Force public schema for company lookup
    ActiveRecord::Base.connection.execute("SET search_path TO public")

    if Company.exists?(subdomain: company_id)
      ActiveRecord::Base.connection.execute(
        "SET search_path TO #{ActiveRecord::Base.connection.quote_table_name(company_id)}, public"
      )
      Rails.logger.info "Switched to schema: #{company_id}"
    else
      raise ActiveRecord::RecordNotFound, "Company not found"
    end
  end

  def set_public_schema
    ActiveRecord::Base.connection.execute("SET search_path TO public")
  end
  
end

=begin
for autoatic schema switching based on subdomain, we can use Apartment's built-in middleware:

# config/initializers/apartment.rb
Apartment.configure do |config|
  # ...

  # Exclude models that should remain in the public schema (e.g., Company model)
  config.excluded_models = %w{ Company }

  # Provide a list of tenant names to Apartment. This can be a static array or a lambda that queries the database.
  # For example, if you have a Company model with a subdomain attribute, you can use:
  config.tenant_names = -> { Company.pluck(:subdomain) }

  # ...
end

# Then, in your application configuration, you can use Apartment's built-in middleware for subdomain-based switching:
# config/application.rb
config.middleware.use Apartment::Elevators::Subdomain
=end