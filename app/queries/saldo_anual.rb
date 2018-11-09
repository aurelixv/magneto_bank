class SaldoAnual
    def self.sum_condition transactions, card, year, is_debt
        transactions
            .where(card_id: card)
            .where("EXTRACT(YEAR FROM transaction_date) BETWEEN #{year} AND 2018")
            .where(is_debt: is_debt)
            .sum("value")
    end
end
