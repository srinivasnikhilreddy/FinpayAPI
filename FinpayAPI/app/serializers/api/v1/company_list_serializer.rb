module Api
  module V1
    class CompanyListSerializer < BaseSerializer
      attributes :id,
             :name,
             :subdomain,
             :created_at
    end
  end
end