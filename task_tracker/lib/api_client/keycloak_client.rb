module ApiClient
  class KeycloakClient
    TIMEOUT = Settings.faraday.default_timeout

    def initialize(
      url: Settings.keycloak.url,
      realm: Settings.keycloak.realm,
      admin_credentials: Settings.keycloak.credentials,
      client_id: Settings.keycloak.client_id
    )
      @keycloak_url = url
      @admin_credentials = admin_credentials
      @realm = realm
      @client_id = client_id
    end

    def get_webhooks
      get_webhooks.select { |webhook| webhook['url'] == Settings.root_url }
    end

    def create_webhook(event_types = ['*'], enabled = true)
      post('/webhooks', {
        "enabled": enabled,
        "url": Settings.root_url,
        "eventTypes": event_types
      })
    end

    def delete_webhook(id)
      delete("webhooks/#{id}")
    end

    private

    def get_all_webhooks
      JSON.parse(get('/webhooks').body)
    end

    def get(path)
      token = get_admin_token
      send_request('get', path, nil, token)
    end

    def put(path, body)
      token = get_admin_token
      send_request('put', path, body, token)
    end

    def post(path, body)
      token = get_admin_token
      send_request('post', path, body, token)
    end

    def delete(path)
      token = get_admin_token
      send_request('delete', path, nil, token)
    end

    def get_admin_token
      response = send_request(
        :post,
        '/protocol/openid-connect/token',
        {
          client_id: @client_id,
          grant_type: 'password',
          username: @admin_credentials.username,
          password: @admin_credentials.password
        },
        nil,
        'application/x-www-form-urlencoded'
      )

      result = JSON.parse(response.body)

      "Bearer #{result['access_token']}"
    end

    def send_request(action, path, body, token = nil, type = 'application/json')
      parameters = prepare_body(type, body)

      response = connection.public_send(action) do |req|
        req.url "/auth/realms/#{@realm}/#{path}"
        req.headers['Authorization'] = token if token
        req.headers['Content-Type'] = type
        req.headers['Accept'] = 'application/json'
        req.body = parameters
        req.options.timeout = TIMEOUT
      end

      response
    rescue Faraday::Error => e
      puts "Ошибка отправки запроса: #{e.class.name}: #{e.message}"
    end

    def connection
      @connection ||= Faraday.new(url: @keycloak_url)
    end

    def prepare_body(type, body)
      case type
      when 'application/json'
        body.to_json
      when 'application/x-www-form-urlencoded'
        URI.encode_www_form(body)
      else
        {}.to_json
      end
    end
  end
end