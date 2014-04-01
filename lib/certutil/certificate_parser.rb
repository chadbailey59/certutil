require 'open3'

class CertificateParser
  include Methadone::CLILogging
  include Methadone::SH


  def self.new_from_input(input)
    new_from_file(File.expand_path(input)) || new_from_hostname(input)
  end

  def self.new_from_file(path)
    # should return nil if it's not a valid cert

    debug "Parsing #{path}..."
    begin
      string = File.read(path)
      if string
        path_array = path.split(File::SEPARATOR)
        debug "Creating..."
        self.new(string: string, name: path_array.last.gsub(/(\.crt)|(.pem)/, ""), source: :file)
      end
    rescue 
      nil
    end
  end

  def self.new_from_hostname(hostname)
    debug "Fetching certificate from #{hostname}..."
    debug "Creating..."
    string = `openssl s_client -connect #{hostname}:443 -showcerts </dev/null`
    self.new(string: string, name: hostname, source: :hostname) unless string == ""
  end

  def self.new_from_gist(gist_link)
    # not yet
  end

  def self.new_from_string(string, opts = {})
    self.new(string: string, name: (opts[:name] || "temp"))
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
    info "Certificate loaded#{' from ' + attrs[:source].to_s if attrs[:source]}: #{@name}."
  end

  def write_crt_files!
    info "Writing separate .crt files..."
    certs.each_with_index do |cert, i|
      debug "right now, wd is #{Dir.pwd}"
      File.open(File.join(@path, "#{@name}-#{i}.crt"), "w") { |f| f.write(cert) }
      debug "--> Wrote #{@path} -- #{@name}-#{i}.crt."
    end
  end

  def write_crt_file!
    info "Writing .crt file..."
    joined = certs.join("\n") + "\n"
    File.open(File.join(@path, "#{@name}.crt"), "w") { |f| f.write(joined) }
    debug "--> Wrote #{@path} -- #{@name}.crt."
  end

  def write_txt_files!
    info "Writing separate .txt files..."
    decoded.each_with_index do |cert, i|
      File.open(File.join(@path, "#{@name}-#{i}-decoded.txt"), "w") { |f| f.write(cert) }
      debug "--> Wrote #{@path}/#{@name}-#{i}-decoded.txt."
    end
  end

  def write_txt_file!
    info "Writing .txt file..."
    joined = decoded.join("\n-----\n") + "\n"
    File.open(File.join(@path, "#{@name}-decoded.txt"), "w") { |f| f.write(joined) }
    debug "--> Wrote #{@path}/#{@name}-decoded.txt."
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
