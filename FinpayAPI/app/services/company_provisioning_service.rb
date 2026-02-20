class CompanyProvisioningService

  def self.call(company)
    schema_name = company.subdomain

    # Create a new schema for the company
    ActiveRecord::Base.connection.execute("CREATE SCHEMA #{schema_name}")

    # Switch to the new schema for the current connection
    ActiveRecord::Base.connection.schema_search_path = schema_name

    # Load the schema for the new tenant (loads application's database schema into the new tenant's schema)
    load Rails.root.join("db/schema.rb")

  ensure
    # Always reset the schema search path to "public" after provisioning to avoid cross-request contamination.
    ActiveRecord::Base.connection.schema_search_path = "public"
  end
end

=begin
automatically create schema for new company using Apartment gem:
class CompanyProvisioningService
  def self.call(company)
    Apartment::Tenant.create(company.subdomain)
  end
end
=end