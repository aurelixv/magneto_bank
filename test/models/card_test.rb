# == Schema Information
#
# Table name: cards
#
#  id                  :bigint(8)        not null, primary key
#  card_type           :boolean
#  card_number         :string
#  verification_number :integer
#  aquisition_date     :date
#  due_date            :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  client_id           :integer
#

require 'test_helper'

class CardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
