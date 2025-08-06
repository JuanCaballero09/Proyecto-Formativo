Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # O mejor: 'http://localhost:PORT' para desarrollo

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
