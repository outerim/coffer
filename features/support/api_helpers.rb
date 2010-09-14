module ApiHelpers
  def api_store(bucket, key, file)
    warn_if_not_test_bucket(bucket)
    put "/#{bucket}/#{key}", file.data, { 'CONTENT_TYPE' => file.type }.merge(authn_headers)
  end

  def api_update(bucket, key, file)
    warn_if_not_test_bucket(bucket)
    post "/#{bucket}/#{key}", file.data, { 'CONTENT_TYPE' => file.type }.merge(authn_headers)
  end

  def api_fetch(bucket, key)
    warn_if_not_test_bucket(bucket)
    get "/#{bucket}/#{key}", {}, authn_headers
  end

  def api_delete(bucket, key)
    delete "/#{bucket}/#{key}", {}, authn_headers
  end

  def warn_if_not_test_bucket(bucket)
    if !DataStore.test_buckets.include? bucket
      $stderr.puts "\n***Warning '#{bucket}' is not a test bucket we actively clear, add it to test_buckets in DataStore.test_buckets***"
    end
  end

  def authn_headers
    @token ? { "API_TOKEN" => @token, "API_KEY" => key_for_token(@token) } : {}
  end

  def key_for_token(token)
    obj = Coffer.tokens.get(token)
    JSON.parse(obj.data)['key']
  rescue => e
    obj = Coffer.tokens.new(token)
    obj.content_type = 'application/json'
    obj.data = { 'key' => rand(1000).to_s }.to_json
    obj.store(:dw => 'all')
    retry
  end
end
