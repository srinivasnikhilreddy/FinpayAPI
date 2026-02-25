module Api
  module V1
    class ApprovalsController < ApplicationController
      before_action :require_manager_or_admin!
      before_action :approval, only: [:show, :update, :destroy]

      def index
        approvals = paginate(Approval.includes(:expense, :approver).order(created_at: :desc))
        
        render json: {
          data: ApprovalSerializer.new(approvals),
          meta: pagination_meta(approvals)
        }
      end

      def show
        render json: ApprovalSerializer.new(approval)
      end

      def create
        approval = Approval.new(approval_params)

        if approval.save
          render json: ApprovalSerializer.new(approval), status: :created
        else
          render json: { error: I18n.t("approvals.create_failed"), details: approval.errors.messages }, status: :unprocessable_entity
        end
      end

      def update
        if approval.update(approval_params)
          AuditLogger.log!(
            user: current_user,
            action: "approval_updated",
            resource: approval,
            request: request,
            metadata: { new_status: approval.status }
          )
          render json: ApprovalSerializer.new(approval)
        else
          render json: {
            error: I18n.t("approvals.update_failed"), details: approval.errors.messages }, status: :unprocessable_entity
        end
      end

      def destroy
        approval.destroy!
        render json: { message: I18n.t("approvals.deleted") }, status: :ok
      end

      private

      def approval
        @approval ||= Approval.find(params[:id])
      end

      def approval_params
        params.require(:approval).permit(:expense_id, :approver_id, :status)
      end
    end
  end
end