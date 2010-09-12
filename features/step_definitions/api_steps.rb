When /^I store a document '([^']+)' as public to '([^']+)\/([^']+)'$/ do |file, bucket, key|
  file = fixture_file(file)
  store bucket, key, file
end

When /^I update '([^']+)\/([^']+)' with '([^']+)'$/ do |bucket, key, file|
  file = fixture_file(file)
  update bucket, key, file
end

Given /^a public document '([^']+)' has been stored at '([^']+)\/([^']+)'$/ do |file, bucket, key|
  file = fixture_file(file)
  store bucket, key, file
end

When /^I request '([^']+)\/([^']+)'$/ do |bucket, key|
  fetch bucket, key
end
