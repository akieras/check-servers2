# encoding: utf-8

require 'socket'
require 'timeout'

module Check
        class Connection
                attr_accessor :ip, :port, :seconds
                def initialize(ip, port, seconds=1)
                        @ip = ip
                        @port = port
                        @seconds = seconds
                end

                def open?
                  Timeout::timeout(seconds) do
                    begin
                      TCPSocket.new(ip, port).close
                      true
                    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError, Errno::EADDRNOTAVAIL
                      false
                    end
                  end
                rescue Timeout::Error
                  false
                end
        end
end
