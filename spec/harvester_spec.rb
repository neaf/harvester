require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe Harvester::Service do
  let(:service) do
    Harvester::Service.new("test-host", "test-email", "test-password")
  end

  describe "#base_url" do
    it "returns full url for given subdomain" do
      service.base_url.should eql("https://test-host.harvestapp.com")
    end
  end

  describe "#rest_resource" do
    it "returns instantiated RestClient resource" do
      service.rest_resource.should be_an_instance_of(RestClient::Resource)
    end

    describe "resource" do
      let(:resource) { service.rest_resource }

      it "has proper credentials set" do
        resource.url.should eql(service.base_url)
        resource.options[:user].should eql("test-email")
        resource.options[:password].should eql("test-password")
      end
    end
  end

  describe "#invoices" do
    it "returns Invoices instance" do
      service.invoices.should be_an_instance_of(Harvester::Invoices)
    end
  end

  describe "#clients" do
    it "returns Clients instance" do
      service.clients.should be_an_instance_of(Harvester::Clients)
    end
  end
end
