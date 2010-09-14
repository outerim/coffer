Given /^I am authenticated to '([^']+)'$/ do |token|
  @token = token
end

Given /^I am an unauthenticated user$/ do
  #noop
end
