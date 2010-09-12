Then /^the request should be successful$/ do
  (200..299).should include(last_response.status)
end

Then /^the request should fail$/ do
  (200..299).should_not include(last_response.status)
end

Then /^the response code should be (\d+)$/ do |code|
  last_response.status.should == code.to_i
end

Then /^the '([^']+)' header should be '([^']+)'$/ do |header, value|
  last_response.headers[header].should == value
end

Then /^the body should be the same as '([^']+)'$/ do |fixture|
  last_response.body.should == fixture_file(fixture).data
end

Then /^the response should be empty$/ do
  last_response.body.should be_empty
end

Then /^it should have an? '([^']+)' header$/ do |header|
  last_response.headers.should have_key(header)
  last_response.headers[header].should_not be_empty
end

