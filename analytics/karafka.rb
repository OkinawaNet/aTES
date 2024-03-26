# frozen_string_literal: true

class KarafkaApp < Karafka::App
  setup do |config|
    config.client_id = Settings.karafka.client_id
    config.kafka = {
      'bootstrap.servers': Settings.karafka.bootstrap_server
    }
  end

  Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)

  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(
      Karafka.logger
    )
  )

  routes.draw do
    topic 'tasks-streaming' do
      consumer TasksStreamingConsumer

      dead_letter_queue(
        topic: 'tasks-streaming-dlq',
        max_retries: 0,
        independent: false
      )
    end

    topic 'tasks-streaming-dlq' do
      consumer TasksStreamingConsumer
    end

    topic 'transactions-workflow' do
      consumer TransactionsWorkflowConsumer
    end
  end
end
