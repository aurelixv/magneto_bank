class SaldoMensal
    def initialize(transactions = Transaction.all)
        @transactions = transactions
    end

    def init_values(values = transactions.("value"))
        @values = values
    end

    def all
        transactions
            .where(card_id: PARAM)
            .where("MONTH(YEAR FROM transaction_date) BETWEEN PARAM AND PARAM")
    end
end
