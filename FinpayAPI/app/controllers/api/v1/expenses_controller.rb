module Api
  module V1
    class ExpensesController < ApplicationController
      before_action :set_expense, only: [:show, :update, :destroy]

      def index
        render json: Expense.all
      end

      def show
        render json: @expense
      end

      def create
        expense = Expense.new(expense_params)
        if expense.save
          render json: expense, status: :created
        else
          render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @expense.update(expense_params)
          render json: @expense
        else
          render json: { errors: @expense.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @expense.destroy
        render json: { message: "Expense deleted successfully" }
      end

      private

      def set_expense
        @expense = Expense.find(params[:id])
      end

      def expense_params
        params.require(:expense).permit(:amount, :description, :status, :user_id, :category_id)
      end
    end
  end
end
