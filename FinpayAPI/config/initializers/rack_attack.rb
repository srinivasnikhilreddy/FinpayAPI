return if Rails.env.test?

class Rack::Attack
  # Use Redis backend (distributed, production-safe)
  # Rate limiting: Restricting how many requests a client can make in a given time period 
  # Throttling: delaying or redusing the speed at which a client that is making too many requests
  # if reaces the limit, the client will be blocked with a 429 Too Many Requests response
  # it protects against Brute force password attack
  # Here, Rack::Attack uses: 👉 Fixed window counter => window = 20 seconds, counter resets after window
  # Memory            | Redis                |
  # ----------------- | -------------------- |
  # Per server        | Sared across servers |
  # Not scalable      | Distributed          |
  # Resets on restart | Persistent           |
  # Without Redis: Server A -> 5 attempts in 20 seconds, Server B -> 5 attempts in 20 seconds => 10 attempts in 20 seconds => allowed
  # With Redis: Sared counter -> only 5 total attempts allowed 

  # This stores counters in a Redis database
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0")
  )

  # Tenant Login Throttle
  # POST /login
  # internally generates key: tenant_login/ip:192.168.1.1, increments counter in redis db by 1, 
  # if counter>=5 within 20 seconds, returns 429 Too Many Requests, after 20 seconds => counter resets
  throttle('tenant_login/ip', limit: 5, period: 20.seconds) do |req|
    req.ip if req.post? && req.path == '/login'
  end
  # 5 login attempts per 20 seconds. if user exceeds this limit, they will be blocked for 20 seconds

  # Platform Login Throttle
  # POST /platform/login
  throttle('platform_login/ip', limit: 5, period: 20.seconds) do |req|
    req.ip if req.post? && req.path == '/platform/login'
  end

  # Transaction Creation
  # POST /api/v1/transactions
  throttle('transactions/user', limit: 20, period: 1.minute) do |req|
    if req.post? && req.path == '/api/v1/transactions'
      req.env['warden']&.user&.id # limits by authenticated user ID => more secure
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
