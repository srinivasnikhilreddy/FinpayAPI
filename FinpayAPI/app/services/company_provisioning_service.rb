class CompanyProvisioningService

  # This service is responsible for provisioning a new schema for a company when it is created.
  # schema defines strucuture of the database and it is used to isolate data for different tenants in a multi-tenant application.
  # When a new company is created, this service will create a new schema for that company and load the necessary database structure into it.
  def self.call(company)
    # Generate a unique schema name based on the company ID
    schema_name = "company_#{company.id}"

    # Create a new schema for the company
    ActiveRecord::Base.connection.execute(
      "CREATE SCHEMA #{schema_name}"
    )

    # Switch to the new schema for the current connection
    ActiveRecord::Base.connection.schema_search_path = schema_name

    # Load the schema for the new tenant
    load Rails.root.join("db/schema.rb")
  end

end
