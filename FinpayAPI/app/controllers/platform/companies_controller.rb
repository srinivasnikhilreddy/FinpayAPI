module Platform
  class CompaniesController < BaseController
    before_action :require_super_admin!
    before_action :set_company, only: [:show, :destroy]

    def index
      companies = paginate(Company.all)
      # render json: { companies: companies } -> like ResponseEntity in Spring Boot
      render json: {
        data: CompanySerializer.new(companies),
        meta: pagination_meta(companies)
      }
    end

    def show
      render json: CompanySerializer.new(@company)
    end

    def create
      @company = CompanyProvisioningService.call!(company_params)

      render json: CompanySerializer.new(@company),
             status: :created

    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages },
             status: :unprocessable_entity
    end

    def destroy
      CompanyDeprovisioningService.call!(@company)

      render json: { message: "Company deleted successfully" },
             status: :ok
    end

    private

    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:name, :subdomain, :admin_name, :admin_email, :admin_password)
    end
  end
end