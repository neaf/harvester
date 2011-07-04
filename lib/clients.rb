require "nokogiri"

module Harvester
  class Client
    attr_accessor :id, :name, :details

    def self.from_node(node)
      self.new.tap do |i|
        i.id = node.xpath("id").first.content.to_i
        i.name = node.xpath("name").first.content
        i.details = node.xpath("details").first.content
      end
    end
  end

  class Clients
    attr_reader :service

    def initialize(service)
      @service = service
    end

    def collection_xml(params = {})
      headers = {
        :content_type => "application/xml",
        :accept => "application/xml"
      }
      xml = service.rest_resource["clients"].get(
        :params => params,
        :headers => headers
      )
    end

    def single_xml(id, params = {})
      headers = {
        :content_type => "application/xml",
        :accept => "application/xml"
      }
      xml = service.rest_resource["clients/#{ id }"].get(
        :params => params,
        :headers => headers
      )
    end

    def all(params = {})
      doc = Nokogiri::XML(collection_xml(params))
      doc.xpath('//client').map do |node|
        Client.from_node(service, node)
      end
    end

    def get(id, params = {})
      doc = Nokogiri::XML(single_xml(id, params))
      Client.from_node(service, doc.xpath('//client').first)
    end
  end
end
