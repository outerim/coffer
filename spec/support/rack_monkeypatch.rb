class Rack::MockResponse
  def etag
    headers['Etag']
  end

  def last_modified
    headers['Last-modified']
  end
end
