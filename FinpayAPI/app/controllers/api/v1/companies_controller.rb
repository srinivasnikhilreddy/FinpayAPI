module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :set_company, only: [:show, :destroy]

      # GET /api/v1/companies
      def index
        render json: Company.all
      end

      # GET /api/v1/companies/:id
      def show
        render json: @company
      end

      # POST /api/v1/companies
      def create
        company = Company.new(company_params)

        begin
          # if companyprovisioning fails, we want to rollback the company creation as well, so we wrap both operations in a transaction
          Company.transaction do
            company.save! # raises ActiveRecord::RecordInvalid if validation fails
            CompanyProvisioningService.call(company)
          end

          render json: company, status: :created

        rescue ActiveRecord::RecordInvalid => e
          render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity

        rescue StandardError => e
          render json: { error: e.message }, status: :internal_server_error
        end
      end

      # DELETE /api/v1/companies/:id
      def destroy
        @company.destroy
        render json: { message: "Company deleted successfully" }, status: :ok
      end

      private

      def set_company
        @company = Company.find(params[:id])
      end

      def company_params
        params.require(:company).permit(:name, :subdomain)
      end
    end
  end
end