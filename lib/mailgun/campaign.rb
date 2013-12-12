module Mailgun

  # Complaints interface. Refer to http://documentation.mailgun.com/api-campaigns.html
  class Campaign
    # Used internally, called from Mailgun::Base
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end

    # List all campaigns
    def list(options={})
      Mailgun.submit(:get, campaign_url, options)["items"] || []
    end

    # Find a campaign by id
    def find(id)
      Mailgun.submit :get, campaign_url(id)
    end

    # Add new campaign
    def add(options={})
      Mailgun.submit :post, campaign_url, options
    end

    # Deletes a campaign
    def destroy(id)
      Mailgun.submit :delete, campaign_url(id)
    end

    def events(id)
      Mailgun.submit :delete, campaign_url("#{id}/events")
    end

    private

    # Helper method to generate the proper url for Mailgun complaints API calls
    def campaign_url(address=nil)
      "#{@mailgun.base_url}/#{@domain}/campaigns#{'/' + address.to_s if address}"
    end

  end
end
