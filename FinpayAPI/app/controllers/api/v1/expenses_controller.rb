module Api
  module V1
    # Employee -> Create Expense -> Manager/Admin Review -> Approve/Reject -> Finance processes payment
    class ExpensesController < ApplicationController
      before_action :expense, only: [:show, :update, :destroy]
      before_action :authorize_expense!, only: [:show, :update, :destroy]

      def index
        # The N+1 problem happens when: You load 1 main query, Then Rails runs N additional queries (one per record), Instead of loading everything in just 1–2 optimized queries
        # We can solve this by using includes method to load all the data at once and avoid N+1 problem
        expenses = if current_user.admin? || current_user.manager?
                    Expense.includes(:user, :category, approvals: :approver) # resolves N+1 problem
                  else
                    current_user.expenses.includes(:category, approvals: :approver) # resolves N+1 problem
                  end
        expenses = paginate(expenses.order(created_at: :desc))

        render json: {
          data: ExpenseSerializer.new(expenses),
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
            error: I18n.t("expeneses.update_failed"),
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

      private

      def expense
        @expense ||= Expense.find(params[:id])
      end

      def expense_params
        params.require(:expense).permit(:amount, :description, :category_id)
      end

      def authorize_expense!
        return if current_user.admin?
        return if expense.user_id == current_user.id && (current_user.employee? || current_user.manager?)
        render_forbidden
      end
    end
  end
end