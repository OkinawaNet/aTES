# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  state       :string
#  public_id   :uuid
#  user_id     :bigint
#  close_price :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Task < ApplicationRecord
  belongs_to :user
  has_many :transactions

  scope :open, -> { where(state: :open) }
  scope :closed, -> { where(state: :closed) }
end
