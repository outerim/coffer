module ApiHelpers
  def store(bucket, key, file)
    put "/#{bucket}/#{key}", file.data, { 'Content-type' => file.type }
  end

  def fetch(bucket, key)
    get "/#{bucket}/#{key}"
  end
end
