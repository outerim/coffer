require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Updating a document" do
  before { 
    @file, @other_file = fixture_file("data.json"), fixture_file("other_data.json")
    as_token("TOKEN1") {
      api_create @bucket = "bucket", @key = "key", @file
      api_get @bucket, @key

      @etag_before = last_response.etag
      @last_mod_before = last_response.last_modified
    }
  }

  share_examples_for "a failing update" do
    before { api_update @bucket, @key, @other_file }

    it "should return an unsuccessful response" do
      last_response.should_not be_successful
    end

    it "should not update the document" do
      api_get @bucket, @key
      last_response.status.should == 200
      last_response.body.should == @file.data
      last_response.etag.should == @etag_before

      # this test is basically bogus, time granularity is 1s could give a false positive
      # last_response.last_modified.should == @last_mod_before
    end
  end

  shared_examples_for "a successful update" do
    before { api_update @bucket, @key, @other_file }

    it "should return a successful response" do
      last_response.status.should == 200
    end

    it "should create the document" do
      api_get @bucket, @key
      last_response.status.should == 200
      last_response.content_type.should == 'application/json'
      last_response.headers.should have_key('Etag')
      last_response.headers.should have_key('Last-modified')
      last_response.body.should == @other_file.data
    end

    it "should update the etag and last modification time" do
      api_update @bucket, @key, @file
      api_get @bucket, @key

      last_response.etag.should_not == @etag_before
      
      # this test is basically bogus, time granularity is 1s could give a false negative
      # last_response.last_modified.should_not == @last_mod_before
    end
  end

  describe "as an unauthenticated user" do
    before { as_unauthenticated }

    it_behaves_like "a failing update"
  end

  describe "as an authenticated user who does not own the bucket" do
    before { as_token "TOKEN2" }

    #it_behaves_like "a failing update"
  end

  describe "as the owner of the bucket" do
    before { as_token "TOKEN1" }

    it_behaves_like "a successful update"
  end
end
