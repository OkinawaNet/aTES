module Jobs
  class CloseBillingCycles
    delegate :logger, to: Rails

    def call
      return unless (DateTime.now.minute % 5).zero?

      User.where(balance: 1..).each do |user|
        logger.info("Closing billing cycle for user #{user.first_name}")

        close_billing_cycle(user)

        logger.info("Closing billing cycle for user #{user.first_name} done")
      end
    end

    def close_billing_cycle(user)
      balance = user.balance
      current_billing_cycle = user.billing_cycles.open.last

      ActiveRecord::Base.transaction do
        Transaction.create(
          user: user,
          description: 'Billing cycle closed',
          credit: balance,
          billing_cycle: current_billing_cycle,
          user_balance: 0
        )

        user.update(balance: 0)
      end

      current_billing_cycle.close!
      BillingCycle.create(user: user)

    rescue => e
      logger.error("Error whern closing billing cycle for user #{user.first_name}")
      logger.error(e.message)
    end
  end
end
