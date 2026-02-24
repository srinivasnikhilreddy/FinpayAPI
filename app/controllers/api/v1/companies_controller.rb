module Api
  module V1
    class CompaniesController < ApplicationController
      def index
        render json: Company.all
      end

      def show
        company = Company.find(params[:id])
        render json: company
      end

      def create
        company = Company.new(company_params)

        begin
          Company.transaction do
            company.save!  # Raises exception if validation fails
            CompanyProvisioningService.call(company) # Create schema
          end

          render json: company, status: :created

        rescue ActiveRecord::RecordInvalid => e
          render json: { errors: company.errors.full_messages }, status: :unprocessable_entity

        rescue => e
          render json: { error: e.message }, status: :internal_server_error
        end
      end

      def destroy
        company = Company.find(params[:id])
        company.destroy
        render json: { message: "Company deleted successfully" }, status: :ok
      end

      private

      def company_params
        params.require(:company).permit(:name, :subdomain)
      end
    end
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