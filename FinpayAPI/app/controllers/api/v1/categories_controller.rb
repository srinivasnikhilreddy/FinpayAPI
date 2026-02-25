module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :require_admin!, except: [:index, :show]
      before_action :category, only: [:show, :update, :destroy]

      def index
        categories = paginate(Category.order(:name))

        render json: {
          data: CategorySerializer.new(categories),
          meta: pagination_meta(categories)
        }
      end

      def show
        render json: CategorySerializer.new(category)
      end

      def create
        category = Category.new(category_params)

        if category.save
          render json: CategorySerializer.new(category), status: :created
        else
          render json: {
            error: I18n.t("categories.create_failed"),
            details: category.errors.messages
          }, status: :unprocessable_entity
        end
      end

      def update
        if category.update!(category_params)
          render json: CategorySerializer.new(@category)
        else
          render json: {
            error: I18n.t("categories.update_failed"),
            details: category.errors.messages
          }, status: :unprocessable_entity
        end
      end

      def destroy
        if category.destroy!
          render json: { message: I18n.t("categories.deleted") }, status: :ok
        else
          render json: {
            error: I18n.t("categories.delete_failed"),
            details: category.errors.messages
          }, status: :unprocessable_entity
        end
      end

      private

      # ||= If @category is nil/false -> fetch from DB, If already loaded -> reuse it. So DB hit happens only once per request.
      def category # memoization is only for finding a single record by params[:id]
        @category ||= Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end