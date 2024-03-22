require_relative 'boot'
require_relative 'environment'
require 'clockwork'

module Clockwork
  every(1.minute, 'close_billing_cycle') do
    Rails.logger.info('GUT')
  end
end
