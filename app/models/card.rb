class Card < ApplicationRecord
    belongs_to :client
    has_many :transactions
end
