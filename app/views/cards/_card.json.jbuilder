json.extract! card, :id, :card_type, :card_number, :verification_number, :aquisition_date, :due_date, :created_at, :updated_at
json.url card_url(card, format: :json)
