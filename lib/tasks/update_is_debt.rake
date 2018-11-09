namespace :tasks do
  desc "Atualiza a coluna is_debt da tabela transaction."
  task :update_is_debt do
    transactions = Transaction.all

    p transactions

    transactions.each do |transaction|
      if rand(0.0..1.0) < 0.25
        transaction.is_debt = false
      else
        transaction.is_debt = true
      end
    end
  end
end
