class SaldoAnual
    def sum_condition transactions, card, year, is_debt
        transactions
            .where(card_id: card)
            .where("EXTRACT(YEAR FROM transaction_date) BETWEEN 2013 AND #{year}")
            .where(is_debt: is_debt)
            .sum("value")
    end
end
