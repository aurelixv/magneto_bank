json.extract! client, :id, :name, :email, :address, :zip_code, :password, :ssid, :birth_date, :created_at, :updated_at
json.url client_url(client, format: :json)
