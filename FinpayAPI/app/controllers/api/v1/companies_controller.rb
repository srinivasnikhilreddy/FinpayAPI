module Api
  module V1
    class CompaniesController < ApplicationController
      def index
        render json: Company.all
      end

      # params means the request body, which is expected to be in JSON format.
      # http://localhost:3000/api/v1/companies/1
      # params[:id] will be 1 in this case, which is used to find the company with id 1 and return it as JSON.
      def show
        company = Company.find(params[:id])
        render json: company
      end

      def create
        company = Company.new(company_params)

        if company.save
          render json: company, status: :created
        else
          render json: { errors: company.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def company_params
        params.require(:company).permit(:name, :subdomain)
      end
    end
  end
end