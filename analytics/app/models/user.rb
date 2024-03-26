# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default("")
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  provider               :string
#  uid                    :string
#  password               :string
#  public_id              :uuid
#  balance                :integer          default(0), not null
#
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[keycloakopenid]

  def self.from_omniauth(auth)
    auth = JSON.parse auth.to_json, object_class: OpenStruct
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.email            = auth.info.email
      user.first_name       = auth.info.first_name
      user.last_name        = auth.info.last_name
      user.password         = Devise.friendly_token[0, 20]
      user.save
    end
  end
end
