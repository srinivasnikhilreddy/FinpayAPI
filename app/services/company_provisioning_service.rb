class CompanyProvisioningService
  def self.call(company)
    schema_name = company.subdomain

    ActiveRecord::Base.connection.execute("CREATE SCHEMA \"#{schema_name}\"")

    ActiveRecord::Base.connection.schema_search_path = schema_name

    load Rails.root.join("db/schema.rb")

  ensure
    ActiveRecord::Base.connection.schema_search_path = "public"
  end
end
