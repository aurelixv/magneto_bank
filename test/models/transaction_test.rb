# == Schema Information
#
# Table name: transactions
#
#  id               :bigint(8)        not null, primary key
#  transaction_type :string
#  value            :float
#  transaction_date :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  card_id          :integer
#  is_debt          :boolean
#

require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
