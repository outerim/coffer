When /^I store a document '([^']+)'(?: as public)? to '([^']+)\/([^']+)'$/ do |file, bucket, key|
  file = fixture_file(file)
  api_store bucket, key, file
end

When /^I update '([^']+)\/([^']+)' with '([^']+)'$/ do |bucket, key, file|
  file = fixture_file(file)
  api_update bucket, key, file
end

Given /^a public document '([^']+)' has been stored at '([^']+)\/([^']+)' for '([^']+)'$/ do |file, bucket, key, token|
  token_was, @token = @token, token
  file = fixture_file(file)
  api_store bucket, key, file
  @token = token_was
end

When /^I request '([^']+)\/([^']+)'$/ do |bucket, key|
  api_fetch bucket, key
end

When /^I delete '([^']+)\/([^']+)'$/ do |bucket, key|
  api_delete bucket, key
end
