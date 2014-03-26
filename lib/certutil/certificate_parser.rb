require 'open3'

class CertificateParser
  include Methadone::CLILogging
  include Methadone::SH

  def self.new_from_file(path)
    info "Parsing #{path}..."
    string = File.read(path)
    path_array = path.split(File::SEPARATOR)
    debug "Creating..."
    self.new(string: string, name: path_array.last.gsub(/(\.crt)|(.pem)/, ""), path: File.dirname(path))
  end

  def self.new_from_hostname(hostname)
    info "Fetching certificate from #{hostname}..."
    debug "Creating..."
    self.new(string: `openssl s_client -connect #{hostname}:443 -showcerts </dev/null`, name: hostname, path: Dir.pwd)
  end

  def certs
    @certs ||= split_input
  end

  def decoded
    debug "lazy loading decoded..."
    @decoded ||= decode
    debug "lazy loading done."

    @decoded
  end

  def initialize(attrs = {})
    @input = attrs[:string]
    @name = attrs[:name]
    @path = Dir.pwd
    debug "Initialized with name: #{@name}, path: #{@path}."
  end

  def write_crt_files!
    info "Writing separate .crt files..."
    certs.each_with_index do |cert, i|
      File.open(File.join(@path, "#{@name}-#{i}.crt"), "w") { |f| f.write(cert) }
      debug "--> Wrote #{@name}-#{i}.crt."
    end
  end

  def write_txt_files!
    info "Writing separate .txt files..."
    decoded.each_with_index do |cert, i|
      File.open(File.join(@path, "#{@name}-#{i}-decoded.txt"), "w") { |f| f.write(cert) }
      debug "--> Wrote #{@name}-#{i}-decoded.txt."
    end
  end

  private

  def split_input
    debug "splitting..."
    matches = @input.scan(/-+BEGIN CERTIFICATE-----.*?-+END CERTIFICATE-+/m)
    matches = matches.map do |cert|
      # cert.gsub!(/-----BEGIN CERTIFICATE-----\n?/, "")
      # cert.gsub!(/-----END CERTIFICATE-----\n?/, "")
      # cert.chomp
      cert
    end

    debug "Found #{matches.count} matches."
    matches
  end

  def decode
    debug "Decoding..."
    output = self.certs.map do |cert|
      Open3.popen3("openssl x509 -text -noout") do |stdin, stdout, stderr|
        stdin.write(cert)
        stdin.close_write
        out = stdout.read
        debug "stdout: #{out}"
        out
      end
    end

    debug "decode output is #{output}."
    output
  end
end
