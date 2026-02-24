class AccountSerializer
  # like DTOs in java spring boot
  include Alba::Resource

  attributes :id,
             :name,
             :balance,
             :created_at,
             :updated_at
end