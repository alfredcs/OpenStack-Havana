#
# Cookbook Name:: nova
# Recipe:: mysql_check
#
# Copyright 2012, The Cloudscaling Group, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "mysql::client"

# Don't converge until mysql is running.
# TODO: verify there is actually a populated database?
ruby_block "check-mysql" do
  block do
    require 'socket'
    require 'timeout'
    begin
      Timeout::timeout(28800) {
        while true do
          begin
            $stderr.puts "Connecting to MySQL."
            socket = Socket.new(
              Socket::Constants::AF_INET,
              Socket::Constants::SOCK_STREAM,
              0
            )
            sockaddr = Socket.pack_sockaddr_in(3306, node['nova']['mysql']['host'])
            socket.connect(sockaddr)
            socket.close()
            $stderr.puts "Connected to MySQL."
            break
          rescue Errno::ECONNREFUSED
            secs=1200
            $stderr.puts "Failed to connect to MySQL waiting #{secs}s"
            sleep secs
          end
        end
      }
    rescue Timeout::Error
      msg="Timeout waiting for MySQL server for OpenStack Nova."
      raise Timeout::Error, msg
    end
  end
end
