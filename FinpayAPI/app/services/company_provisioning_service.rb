class CompanyProvisioningService
  def self.call!(params)
    subdomain = params[:subdomain]

    Rails.logger.info("[CompanyProvisioning] Starting provisioning for #{subdomain}")

    Company.transaction do
      company = Company.create!(
        name: params[:name],
        subdomain: subdomain
      )

      Apartment::Tenant.create(subdomain)

      Apartment::Tenant.switch(subdomain) do
        User.create!(
          name: params[:admin_name] || "Admin",
          email: params[:admin_email],
          password: params[:admin_password],
          role: "admin"
        )
      end

      Rails.logger.info("[CompanyProvisioning] Successfully provisioned #{subdomain}")

      company
    end

  rescue Apartment::TenantExists
    Rails.logger.error("[CompanyProvisioning] Schema already exists: #{subdomain}")
    raise ActiveRecord::RecordInvalid.new(Company.new(params))

  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.warn("[CompanyProvisioning] Validation failed: #{e.message}")
    raise e

  rescue => e
    Rails.logger.error("[CompanyProvisioning] Failed: #{e.class} - #{e.message}")
    raise e
  end
end