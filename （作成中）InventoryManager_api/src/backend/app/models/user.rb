class User < ApplicationRecord
  has_secure_password

  validates :workplace_id, presence: true, uniqueness: true
  validates :password, presence: true
end