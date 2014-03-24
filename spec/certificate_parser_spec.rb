require 'spec_helper'

describe CertificateParser do
  before :all do
    @string_data = <<-doc
-----BEGIN CERTIFICATE-----
abcdef
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
123456
-----END CERTIFICATE-----
doc
  end

  describe ".new_from_file" do
    it "creates an instance from a file path" do
      @cp = CertificateParser.new_from_file("features/google-full.crt")
      expect(@cp).to be_a(CertificateParser)
      expect(@cp.certs.length).to eq(2)
    end
  end

  describe "#certs" do
    it "splits a cert string into an array" do
      @cp = CertificateParser.new(@string_data)
      expect(@cp.certs.count).to eq(2)
      expect(@cp.certs[0]).to eq("abcdef")
      expect(@cp.certs[1]).to eq("123456")
    end
  end

  describe "decoded" do
    it "decodes certificates" do
      @cp = CertificateParser.new_from_file("features/google-full.crt")
      @cp.decoded.first.should include("Google")
    end
  end
end
    
