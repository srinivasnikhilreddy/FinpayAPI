# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors


# uncommented the following lines to allow CORS requests from any origin. You can restrict this in production by replacing '*' with the actual domain of your frontend app.
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: [:Authorization] # Expose the Authorization header to the frontend/client/postman application
  end
end
