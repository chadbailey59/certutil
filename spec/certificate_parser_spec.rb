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

  describe ".new_from_hostname" do
    it "creates a CertificateParser from a valid file" do
      @cp = CertificateParser.new_from_file(File.join(Dir.pwd, "features/google-full.crt"))
      expect(@cp).to be_a CertificateParser
      expect(@cp.certs).to be_a Array
    end

    it "returns nil if the file doesn't exist" do
      @cp = CertificateParser.new_from_file(File.join(Dir.pwd, "nil.crt"))
      expect(@cp).to be_nil
    end
  end

  describe ".new_from_file" do
    it "creates a CertificateParser from a valid hostname" do
      @cp = CertificateParser.new_from_hostname("google.com")
      expect(@cp).to be_a CertificateParser
      expect(@cp.certs).to be_a Array
    end

    it "returns nil if it can't find a certificate" do
      @cp = CertificateParser.new_from_hostname("fake.domain")
      expect(@cp).to be_nil
    end
  end

  describe ".new_from_input" do
    it "creates a CertificateParser from hostname" do
      expect(CertificateParser.new_from_hostname("google.com")).to be_a CertificateParser
    end

    it "creates a CertificateParser from a file" do
      expect(CertificateParser.new_from_file(File.join(Dir.pwd, "features/google-full.crt"))).to be_a CertificateParser
    end
  end

  describe "#certs" do
    it "splits a cert string into an array" do
      @cp = CertificateParser.new_from_string(@string_data)
      expect(@cp.certs.count).to eq(2)
      expect(@cp.certs[0]).to include("abcdef")
      expect(@cp.certs[1]).to include("123456")
    end
  end

  describe "decoded" do
    it "decodes certificates" do
      @cp = CertificateParser.new_from_file("features/google-full.crt")
      @cp.decoded.first.should include("Google")
    end
  end
end
    
