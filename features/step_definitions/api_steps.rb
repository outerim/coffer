When /^I store a document '([^']+)' as public to '([^']+)\/([^']+)'$/ do |file, bucket, key|
  file = fixture_file(file)
  
  put "/#{bucket}/#{key}", file.data, { 'Content-type' => file.type }
end

Then /^the request should succeed$/ do
  (200..299).should include(last_response.status)
end

