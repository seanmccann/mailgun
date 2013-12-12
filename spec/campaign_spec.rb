require 'spec_helper'

describe Mailgun::Campaign do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})

    @sample = {
      :id  => 1,
      :name   => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "list campaign" do
    it "should make a GET request with the right params" do
      sample_response = <<EOF
{
  "total_count": 1,
  "items": [
      {
          "count": 2,
          "created_at": "Tue, 15 Nov 2011 08:25:11 GMT",
          "address": "romanto@profista.com"
      }
  ]
}
EOF

      campaign_url = @mailgun.campaigns(@sample[:domain]).send(:campaign_url)

      Mailgun.should_receive(:submit).
        with(:get, campaign_url, {}).
        and_return(sample_response)

      @mailgun.campaigns(@sample[:domain]).list
    end
  end


  describe "add campaigns" do
    it "should make a POST request with correct params to add a given email address to campaigns from a tag" do
      sample_response = <<EOF
{
  "message": "Address has been added to the campaigns table",
  "address": "#{@sample[:email]}"
}
EOF

      campaign_url = @mailgun.campaigns(@sample[:domain]).send(:campaign_url)

      Mailgun.should_receive(:submit)
        .with(:post, campaign_url, {name: @sample[:name]})
        .and_return(sample_response)

      @mailgun.campaigns(@sample[:domain]).add({name: @sample[:name]})
    end
  end


  describe "find campaigns" do
    it "should make a GET request with the right params to find given email address" do
      sample_response = <<EOF
{
  "campaigns": {
      "count": 2,
      "created_at": "Tue, 15 Nov 2011 08:25:11 GMT",
      "address": "romanto@profista.com"
  }
}
EOF

      campaign_url = @mailgun.campaigns(@sample[:domain]).send(:campaign_url, @sample[:id])

      Mailgun.should_receive(:submit)
        .with(:get, campaign_url)
        .and_return(sample_response)

      @mailgun.campaigns(@sample[:domain]).find(@sample[:id])
    end
  end


  describe "delete campaigns" do
    it "should make a DELETE request with correct params to remove a given email address" do
      sample_response = <<EOF
{
    "message": "campaigns event has been removed",
    "address": "#{@sample[:email]}"}"
}
EOF

      campaign_url = @mailgun.campaigns(@sample[:domain]).send(:campaign_url, @sample[:email])

      Mailgun.should_receive(:submit)
        .with(:delete, campaign_url)
        .and_return(sample_response)

      @mailgun.campaigns(@sample[:domain]).destroy(@sample[:email])
    end
  end

end
