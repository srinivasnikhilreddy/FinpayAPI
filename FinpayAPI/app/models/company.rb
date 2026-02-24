class Company < ApplicationRecord
  # executes the provisioning service after a company record is created
  after_create :provision_schema

  private

  # This method calls the CompanyProvisioningService to create a new schema for the company after it is created.
  def provision_schema
    CompanyProvisioningService.call(self)
  end
end
