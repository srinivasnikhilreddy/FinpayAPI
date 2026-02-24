# config/initializers/rack_attack.rb

class Rack::Attack
  # Use Redis backend (distributed, production-safe)
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0")
  )

  # Tenant Login Throttle
  # POST /login
  throttle('tenant_login/ip', limit: 5, period: 20.seconds) do |req|
    req.ip if req.post? && req.path == '/login'
  end

  # Platform Login Throttle
  # POST /platform/login
  throttle('platform_login/ip', limit: 5, period: 20.seconds) do |req|
    req.ip if req.post? && req.path == '/platform/login'
  end

  # Transaction Creation
  # POST /api/v1/transactions
  throttle('transactions/user', limit: 20, period: 1.minute) do |req|
    if req.post? && req.path == '/api/v1/transactions'
      req.env['warden']&.user&.id
    end
  end

  # Company Creation
  # POST /platform/companies
  throttle('company_creation/ip', limit: 3, period: 1.minute) do |req|
    req.ip if req.post? && req.path == '/platform/companies'
  end

  # Custom JSON 429
  Rack::Attack.throttled_responder = lambda do |request|
    [
      429,
      { 'Content-Type' => 'application/json' },
      [{ error: 'Rate limit exceeded. Please try again later.' }.to_json]
    ]
  end
end





git add config/initializers/devise.rb

git add config/routes.rb

git add db/migrate/20260224185046_add_user_to_accounts.rb
git add db/schema.rb

git add Gemfile
git add Gemfile.lock