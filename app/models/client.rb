class Client < ApplicationRecord
    has_many :cards
    has_many :transactions, through: :cards
end
