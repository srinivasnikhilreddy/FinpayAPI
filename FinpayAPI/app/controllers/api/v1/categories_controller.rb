module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :require_admin!, except: [:index, :show]
      before_action :set_category, only: [:show, :update, :destroy]

      def index
        categories = paginate(Category.order(:name))

        render json: {
          data: CategorySerializer.new(categories),
          meta: pagination_meta(categories)
        }
      end

      def show
        render json: CategorySerializer.new(@category)
      end

      def create
        @category = Category.new(category_params)

        if @category.save
          render json: CategorySerializer.new(@category), status: :created
        else
          render json: {
            error: "Category couldn't be created",
            details: @category.errors.messages
          }, status: :unprocessable_entity
        end
      end

      def update
        if @category.update!(category_params)
          render json: CategorySerializer.new(@category)
        else
          render json: {
            error: "Category couldn't be updated",
            details: @category.errors.messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        if @category.destroy!
          render json: { message: "Category deleted successfully" }, status: :ok
        else
          render json: {
            error: "Category couldn't be deleted",
            details: @category.errors.messages
          }, status: :unprocessable_entity
        end
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end