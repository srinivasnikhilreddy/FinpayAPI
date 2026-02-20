module Api
  module V1
    class ApprovalsController < ApplicationController
      before_action :set_approval, only: [:show, :update, :destroy]

      def index
        render json: Approval.all
      end

      def show
        render json: @approval
      end

      def create
        approval = Approval.new(approval_params)
        if approval.save
          render json: approval, status: :created
        else
          render json: { errors: approval.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @approval.update(approval_params)
          render json: @approval
        else
          render json: { errors: @approval.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @approval.destroy
        render json: { message: "Approval deleted successfully" }
      end

      private

      def set_approval
        @approval = Approval.find(params[:id])
      end

      def approval_params
        params.require(:approval).permit(:expense_id, :approver_id, :status)
      end
    end
  end
end
