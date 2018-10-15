class Card < ApplicationRecord
    belongs_to :client, optional: true
    has_many :transactions
end
