class CompanySerializer
  include Alba::Resource

  attributes :id,
             :name,
             :subdomain,
             :created_at,
             :updated_at
end