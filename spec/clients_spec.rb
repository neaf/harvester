require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

collection_xml = File.read(File.expand_path(File.dirname(__FILE__) + "/fixtures/client_collection.xml"))
single_xml = File.read(File.expand_path(File.dirname(__FILE__) + "/fixtures/client_single.xml"))

describe Harvester::Client do
  let(:service) do
    Harvester::Service.new("test-host", "test-email", "test-password")
  end

  describe ".from_node" do
    let(:node) do
      Nokogiri::XML(collection_xml).xpath("//client").first
    end

    it "returns Client instance" do
      Harvester::Client.from_node(node).should be_an_instance_of(Harvester::Client)
    end

    describe "client" do
      let(:client) do
        Harvester::Client.from_node(node)
      end

      it "has proper attributes set" do
        client.id.should eql(11072)
        client.name.should eql("SuprCorp")
      end
    end
  end
end
