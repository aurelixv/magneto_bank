class Transaction < ApplicationRecord
  belongs_to :card, optional: true
  has_one :client, through: :card
end
