# :nocov:
module PgEngine
  class SslVerifier
    OUTPUT_PATH = 'tmp/ssl_verifier.json'.freeze

    def run
      PgEngine.config.health_ssl_urls.each do |url|
        check_ssl(url)
      end
    end

    def check_ssl(url)
      uri = URI.parse(url)
      http_session = Net::HTTP.new(uri.host, uri.port)

      # Use SSL/TLS
      http_session.use_ssl = true

      # Create a request
      request = Net::HTTP::Get.new(uri.request_uri)

      begin
        # Start the HTTP session
        http_session.start do |http|
          http.request(request)

          # Check the response code

          # Get the SSL certificate
          cert = http.peer_cert

          raise PgEngine::Error, "#{url}: No SSL certificate found." unless cert
          # puts "Certificate Subject: #{cert.subject}"
          # puts "Certificate Issuer: #{cert.issuer}"
          # puts "Certificate Valid From: #{cert.not_before}"
          # puts "Certificate Valid Until: #{cert.not_after}"

          if cert.not_after < 7.days.from_now
            raise PgEngine::Error, "#{url}: The SSL certificate is expired (or about to expire)."
          end

          log_output(url, cert.not_after)
        end
      rescue OpenSSL::SSL::SSLError => e
        raise PgEngine::Error, "#{url}: SSL Error: #{e.message}"
      rescue StandardError => e
        raise PgEngine::Error, "#{url}: An error occurred: #{e.message}"
      end
    end

    def log_output(url, expires_at)
      current_content =
        if File.exist?(OUTPUT_PATH)
          JSON.parse(File.read(OUTPUT_PATH))
        else
          {}
        end

      current_content[url] = { verified_at: Time.current, expires_at: }

      File.write(OUTPUT_PATH, current_content.to_json)
    end
  end
end
# :nocov:
