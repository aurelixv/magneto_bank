class Transaction < ApplicationRecord
    belongs_to :card, optional: true
end
