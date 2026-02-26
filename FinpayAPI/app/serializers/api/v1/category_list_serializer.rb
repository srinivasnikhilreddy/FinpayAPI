module Api
  module V1
    class CategoryListSerializer < BaseSerializer

      attributes :id,
                :name,
                :created_at
    end
  end
end