# == Schema Information
#
# Table name: billing_cycles
#
#  id         :bigint           not null, primary key
#  start_at   :datetime
#  finish_at  :datetime
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :string
#
require "test_helper"

class BillingCycleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
