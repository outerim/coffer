require File.dirname(__FILE__) + "/spec_helper.rb"

describe "Deleting a document" do
  shared_examples_for "a failing delete" do
    it { last_response.should_not be_successful }

    it "does not remove the document" do
      api_get @bucket, @key
      last_response.should be_successful
    end
  end

  describe "that exists" do
    before {
      as_token "TOKEN1"
      api_create @bucket = "bucket", @key = "key"
    }

    describe "as an unauthenticated user" do
      before { as_unauthenticated; api_delete @bucket, @key }
      
      it_behaves_like "a failing delete"
      it { last_response.status.should == 403 }
    end
    
    describe "as an authenticated user who does not own the document" do
      before { as_token "TOKEN2"; api_delete @bucket, @key }
      
      # Pending, need to add this functionality
      # it_behaves_like "a failing delete"
    end

    describe "as the owner of the document" do
      before { api_delete @bucket, @key }

      it "returns a successful status code" do
        last_response.status.should == 204
      end

      it "removes the document" do
        api_get @bucket, @key
        last_response.status.should == 404
        last_response.body.should be_empty
      end
    end
  end

  describe "that doesn't exist" do
    before { as_token "TOKEN1"; api_delete "bucket", "nonexistentkey" }
    
    it { last_response.status.should == 404 }
  end
end
