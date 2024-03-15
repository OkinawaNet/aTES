class KarafkaApp < Karafka::App
  setup do |config|
    config.client_id = Settings.karafka.client_id
    config.kafka = {
      'bootstrap.servers': Settings.karafka.bootstrap_server
    }
  end
end