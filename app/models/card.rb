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

class Card < ApplicationRecord
  belongs_to :client, optional: true
  has_many :transactions

  before_save :set_due_date

  def set_due_date
    self.due_date = aquisition_date.next_year(5)
  end
end
