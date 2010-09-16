require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Creating a document" do
  before { @bucket, @key = "bucket", "key" }

  share_examples_for "a failing create" do
    before { api_create @bucket, @key }

    it "should return an unsuccessful response" do
      last_response.should_not be_successful
    end

    it "should not create the document" do
      api_get @bucket, @key
      last_response.status.should == 404
      last_response.body.should be_empty
    end
  end

  shared_examples_for "a successful create" do
    before { @file = api_create @bucket, @key }

    it "should return a successful response" do
      last_response.status.should == 200
    end

    it "should create the document" do
      api_get @bucket, @key
      last_response.status.should == 200
      last_response.content_type.should == 'application/json'
      last_response.headers.should have_key('Etag')
      last_response.headers.should have_key('Last-modified')
      last_response.body.should == @file.data
    end
  end

  describe "as an unauthenticated user" do
    before { as_unauthenticated }

    it_behaves_like "a failing create"
  end
  
  describe "as an authenticated user who does not own the bucket" do
    before { as_token "TOKEN2" }

    #it_behaves_like "a failing create"
  end

  describe "as the owner of the bucket" do
    before { as_token "TOKEN1" }

    it_behaves_like "a successful create"
  end
end
