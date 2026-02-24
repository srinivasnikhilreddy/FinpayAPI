class CompanyDeprovisioningService
  def self.call!(company)
    subdomain = company.subdomain

    Rails.logger.info("[CompanyDeprovisioning] Dropping #{subdomain}")

    # Apartment will raise if schema does not exist
    Apartment::Tenant.drop(subdomain)

    company.destroy!

    Rails.logger.info("[CompanyDeprovisioning] Successfully removed #{subdomain}")

  rescue Apartment::TenantNotFound
    Rails.logger.warn("[CompanyDeprovisioning] Schema not found: #{subdomain}")
    raise

  rescue => e
    Rails.logger.error("[CompanyDeprovisioning] Failed: #{e.class} - #{e.message}")
    raise e
  end
end
