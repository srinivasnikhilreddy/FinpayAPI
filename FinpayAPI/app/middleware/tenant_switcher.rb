class TenantSwitcher
  # This middleware switches the database schema based on the "X-Company-ID" header in the incoming request.
  def initialize(app)
    @app = app
  end

  # The call method is invoked for each incoming request. It checks for the presence of the "X-Company-ID" header and sets the database schema accordingly.
  # If the header is not present, it defaults to the "public" schema.
  def call(env)
    # Rack is a modular Ruby webserver interface that allows us to access the incoming request and its headers.
    request = Rack::Request.new(env)
    company_id = request.get_header("HTTP_X_COMPANY_ID")

    if company_id
      schema = "company_#{company_id}"
      ActiveRecord::Base.connection.schema_search_path = schema
      
      Rails.logger.info "Switching to schema: #{schema}"
    else
      ActiveRecord::Base.connection.schema_search_path = "public"
    end

    # Call the next middleware in the stack or the main application. This ensures that the request is processed with the correct database schema.
    @app.call(env)
  ensure
    ActiveRecord::Base.connection.schema_search_path = "public"
  end
end
