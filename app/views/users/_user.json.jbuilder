json.extract! user, :id, :email, :password_digest, :name, :is_auth, :is_valid, :created_at, :updated_at
json.url user_url(user, format: :json)
