# SSL patch to work around CRL checking issue on macOS
# This accepts all certificates to bypass CRL checking errors
require 'openssl'
require 'net/http'

# Patch Net::HTTP to accept all certificates (workaround for macOS CRL issues)
module Net
  class HTTP
    alias_method :original_start, :start
    
    def start(&block)
      # Set verify callback before starting connection
      if use_ssl?
        begin
          self.verify_callback = proc { |preverify_ok, store_context| true }
        rescue => e
          # Ignore errors
        end
      end
      original_start(&block)
    end
  end
end

