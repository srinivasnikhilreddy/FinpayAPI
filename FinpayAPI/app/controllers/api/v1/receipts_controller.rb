module Api
  module V1
    class ReceiptsController < ApplicationController
      before_action :receipt, only: [:show, :update, :destroy]
      before_action :require_admin!, only: [:destroy]

      def index
        expense = base_scope

        render json: ReceiptListSerializer.new(expense.receipts)
      end

      def show
        render json: ReceiptSerializer.new(receipt)
      end

      def create
        expense = base_scope

        receipt = expense.receipts.build(receipt_params.except(:expense_id))

        if receipt.save
          render json: ReceiptSerializer.new(receipt), status: :created
        else
          render json: { errors: receipt.errors.full_messages },
                status: :unprocessable_entity
        end
      end

      def update
        if receipt.update(receipt_params.except(:expense_id))
          render json: ReceiptSerializer.new(receipt)
        else
          render json: { errors: receipt.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        receipt.destroy
        head :no_content
      end

      private

      def base_scope
        @base_scope ||=
          if current_user.admin? || current_user.manager?
            Expense.find(params[:expense_id]) # return expense object by id
          else
            current_user.expenses.find(params[:expense_id])
          end
      end

      def receipt
        @receipt =
          if current_user.admin? || current_user.manager?
            Receipt.find(params[:id])
          else
            Receipt.joins(:expense)
                   .where(expenses: { user_id: current_user.id })
                   .find(params[:id])
          end
      end

      def receipt_params
        params.require(:receipt)
              .permit(:file_url, :amount)
      end
    end
  end
end