# app/serializers/api/v1/base_serializer.rb
module Api
  module V1
    class BaseSerializer
      # like DTOs in java spring boot
      # Alba serializer is one of the fastest JSON serializers available for ruby
      include Alba::Resource
    end
  end
end