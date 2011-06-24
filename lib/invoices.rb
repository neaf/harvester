require "nokogiri"

module Harvester
  class Invoice
    attr_accessor :id, :number, :total_amount, :due_amount, :issued_on, :due_on, :currency

    def self.from_node(node)
      self.new.tap do |i|
        i.id = node.xpath("./id").first.content.to_i
        i.number = node.xpath("./number").first.content
        i.total_amount = node.xpath("./amount").first.content.to_f
        i.due_amount = node.xpath("./due-amount").first.content.to_f
        i.issued_on = Date.strptime(node.xpath("./issued-at").first.content, "%Y-%m-%d")
        i.due_on = Date.strptime(node.xpath("./due-at").first.content, "%Y-%m-%d")
        i.currency = node.xpath("./currency").first.content[/\w{3}$/]
      end
    end
  end

  class Invoices
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def all(params = {})
      doc = Nokogiri::XML(client.rest_resource["invoices"].get(:params => params, :headers => { :content_type => 'application/xml', :accept => 'application/xml' }))
      doc.xpath('//invoice').map do |node|
        Invoice.from_node(node)
      end
    end

    def get(id)
      doc = XmlSimple.xml_in(client.rest_resource["invoices/#{ id }"].get, { "ForceArray" => false })
      Invoice.from_hash(doc)
    end
  end
end
