require 'rest-client'
require 'invoices'

module Harvester
  class Service
    attr_reader :subdomain, :email, :password, :rest_resource

    def initialize(subdomain, email, password)
      @subdomain = subdomain
      @email = email
      @password = password
      @rest_resource = RestClient::Resource.new(base_url,
                                                email,
                                                password)
    end

    def base_url
      "https://#{ subdomain }.harvestapp.com"
    end

    def invoices
      @invoices ||= Harvester::Invoices.new(self)
    end
  end
end
