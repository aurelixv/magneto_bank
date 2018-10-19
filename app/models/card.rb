class Card < ApplicationRecord
    belongs_to :client, optional: true
    has_many :transactions

    before_save :set_due_date

    def set_due_date
        self.due_date = self.aquisition_date.next_year(5)
    end
end
