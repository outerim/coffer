module ApiHelpers
  def api_store(bucket, key, file)
    warn_if_not_test_bucket(bucket)
    put "/#{bucket}/#{key}", file.data, { 'Content-type' => file.type }
  end

  def api_update(bucket, key, file)
    warn_if_not_test_bucket(bucket)
    post "/#{bucket}/#{key}", file.data, { 'Content-type' => file.type }
  end

  def api_fetch(bucket, key)
    warn_if_not_test_bucket(bucket)
    get "/#{bucket}/#{key}"
  end

  def api_delete(bucket, key)
    delete "/#{bucket}/#{key}"
  end

  def warn_if_not_test_bucket(bucket)
    if !DataStore.test_buckets.include? bucket
      $stderr.puts "\n***Warning '#{bucket}' is not a test bucket we actively clear, add it to test_buckets in DataStore.test_buckets***"
    end
  end
end
