json.array!(@contents) do |content|
  json.extract! content, :id, :type, :is_public, :dblink, :user_id
  json.url content_url(content, format: :json)
end
