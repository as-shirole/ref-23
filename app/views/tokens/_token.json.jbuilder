json.extract! token, :id, :web_token, :created_at, :updated_at
json.url token_url(token, format: :json)