require 'rest-client'
require 'invoices'
require 'clients'

module Harvester
  class Service
    attr_reader :subdomain, :email, :password, :rest_resource
    attr_reader :invoices, :clients

    def initialize(subdomain, email, password)
      @subdomain = subdomain
      @email = email
      @password = password
      @rest_resource = RestClient::Resource.new(base_url,
                                                email,
                                                password)
      @invoices = Harvester::Invoices.new(self)
      @clients = Harvester::Clients.new(self)
    end

    def base_url
      "https://#{ subdomain }.harvestapp.com"
    end
  end
end
