module Api
  module V1
    class CompanySerializer < BaseSerializer
      attributes :id,
             :name,
             :subdomain,
             :created_at,
             :updated_at
    end
  end
end