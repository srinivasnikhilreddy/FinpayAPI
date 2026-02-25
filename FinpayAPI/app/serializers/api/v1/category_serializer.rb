module Api
  module V1
    class CategorySerializer < BaseSerializer

      attributes :id,
                :name,
                :created_at,
                :updated_at
    end
  end
end