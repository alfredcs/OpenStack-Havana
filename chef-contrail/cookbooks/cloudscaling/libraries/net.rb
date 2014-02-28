#
# OCS Module for various networking methods
# Copyright Cloudscaling
# Author: Joseph Glanville <joseph@cloudscaling.com>
#

require 'socket'
require 'timeout'

module OCS
  module Net
    class << self

      def is_port_open?(ip, port)
        begin
          Timeout::timeout(1) do
            begin
              s = TCPSocket.new(ip, port)
              s.close
              return true
            rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
              return false
            end
          end
        rescue Timeout::Error
        end

        return false
      end

      def wait_for_port(ip, port, timeout=10)
        Timeout::timeout(timeout) do
          while !is_port_open?(ip, port)
            begin
                sleep 1
            end
          end
        end
      end

    end
  end
end
