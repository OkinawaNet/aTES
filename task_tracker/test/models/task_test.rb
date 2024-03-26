# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  state       :string
#  public_id   :uuid             not null
#  user_id     :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string
#
require "test_helper"

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
