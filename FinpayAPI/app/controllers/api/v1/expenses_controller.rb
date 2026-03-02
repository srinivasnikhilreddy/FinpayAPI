module Api
  module V1
    # Employee -> Create Expense -> Manager/Admin Review -> Approve/Reject -> Finance processes payment
    class ExpensesController < ApplicationController
      before_action :expense, only: [:show, :update, :destroy, :approve, :reject]
      before_action :authorize_expense!, only: [:show, :update, :destroy]
      before_action :authorize_manager!, only: [:approve, :reject, :reimburse, :archive]

      def index
        expenses = base_scope
                      .active
                      .filter_by(filtering_params)
                      .order(created_at: :desc)

        expenses = paginate(expenses)

        render json: {
          data: ExpenseListSerializer.new(expenses),
          meta: pagination_meta(expenses)
        }
      end

      def show
        render json: ExpenseSerializer.new(expense)
      end

      def create
        expense = current_user.expenses.build(expense_params)
        if expense.save
          AuditLogger.log!(
            user: current_user,
            action: I18n.t("expenses.created"),
            resource: expense,
            request: request
          )
          render json: ExpenseSerializer.new(expense), status: :created
        else
          render json: { error: I18n.t("expenses.create_failed"), details: expense.errors.messages }, status: :unprocessable_entity
        end
      end

      def update
        if expense.update(expense_params)
          render json: ExpenseSerializer.new(expense)
        else
          render json: {
            error: I18n.t("expenses.update_failed"),
            details: expense.errors.messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        expense.soft_delete!

        AuditLogger.log!(
          user: current_user,
          action: "expense_soft_deleted",
          resource: expense,
          request: request
        )

        render json: { message: I18n.t("expenses.deleted") }
      end

      def approve
        service = ExpenseWorkflowService.new(
          expense: expense,
          actor: current_user,
          request: request
        )

        service.approve!

        render json: ExpenseSerializer.new(expense)
      rescue AASM::InvalidTransition
        render_unprocessable("Invalid state transition")
      end

      def reject
        service = ExpenseWorkflowService.new(
          expense: expense,
          actor: current_user,
          request: request
        )

        service.reject!

        render json: ExpenseSerializer.new(expense)
      rescue AASM::InvalidTransition
        render_unprocessable("Invalid state transition")
      end

      private

      def filtering_params
        params.permit(
          :by_category,
          :by_status,
          :from_date,
          :to_date
        )
      end

      def base_scope
        # The N+1 problem happens when: You load 1 main query, Then Rails runs N additional queries (one per record), Instead of loading everything in just 1–2 optimized queries
        # We can solve this by using includes method to load all the data at once and avoid N+1 problem
        @base_scope ||=
        if current_user.admin? || current_user.manager?
          Expense.includes(:user, :category) # resolves N+1 problem
        else
          current_user.expenses.includes(:category) # resolves N+1 problem
        end
      end

      def expense
        @expense ||= base_scope.find(params[:id])
      end

      def expense_params
        params.require(:expense).permit(:amount, :description, :category_id)
      end

      def authorize_expense!
        return if current_user.admin?
        return if expense.user == current_user && (current_user.employee? || current_user.manager?)
        render_forbidden
      end
    end
  end
end