Then /^the request should be successful$/ do
  (200..299).should include(last_response.status)
end

Then /^the '([^']+)' header should be '([^']+)'$/ do |header, value|
  last_response.headers[header].should == value
end

Then /^the body should be the same as '([^']+)'$/ do |fixture|
  last_response.body.should == fixture_file(fixture).data
end

