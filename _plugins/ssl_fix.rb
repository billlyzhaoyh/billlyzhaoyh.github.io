# SSL fix for CRL checking issue on macOS
# This must be loaded before jekyll-remote-theme downloads themes

require 'openssl'
require 'net/http'

# Patch Net::HTTP to disable CRL checking
module Net
  class HTTP
    alias_method :original_use_ssl=, :use_ssl=
    
    def use_ssl=(flag)
      original_use_ssl=(flag)
      if flag && @socket
        # Disable CRL checking
        @socket.context.verify_flags = OpenSSL::SSL::OP_NO_CRL_CHECK
      end
    end
    
    alias_method :original_connect, :connect
    
    def connect
      original_connect
      # Disable CRL checking after connection
      if use_ssl? && @socket && @socket.context
        @socket.context.verify_flags = OpenSSL::SSL::OP_NO_CRL_CHECK
      end
    end
  end
end

# Also patch OpenSSL::SSL::SSLContext to set verify flags
module OpenSSL
  module SSL
    class SSLContext
      alias_method :original_setup, :setup
      
      def setup
        original_setup
        # Disable CRL checking
        self.verify_flags = OpenSSL::SSL::OP_NO_CRL_CHECK
      end
    end
  end
end

