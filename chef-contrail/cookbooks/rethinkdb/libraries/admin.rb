require 'net/http'
require 'json'

module RethinkDB
  module Admin
    class Client

      def initialize(server, port)
        @server = Net::HTTP.new(server, port)
      end

      def get_ajax
        req = Net::HTTP::Get.new('/ajax')
        JSON.load(@server.request(req).body)
      end

      def machines
        data = get_ajax
        data['semilattice']['machines'].map do |id, machine|
          reachable = true ? data['directory'].has_key?(id) : false
          ips = reachable ? data['directory'][id]['ips'] : nil
          {
            id: id,
            name: machine['name'],
            reachable: reachable,
            ips: ips
          }
        end
      end

      def databases
        lattice = get_ajax['semilattice']
        lattice['databases'].map do |id, db|
          {
            id: id,
            name: db['name']
          }
        end
      end

      def tables
        lattice = get_ajax['semilattice']
        lattice['rdb_namespaces'].map do |id, table|
          acks = table['ack_expectations'].values.map {|t| t['expectation']}.reduce(:+)
          replicas = table['replica_affinities'].empty? ? 1 : table['replica_affinities'].values.reduce(:+) + 1
          {
            id: id,
            name: table['name'],
            acks: acks,
            replicas: replicas
          }
        end
      end

      def issues
        get_ajax['issues']
      end

      def delete_machine(id)
        req = Net::HTTP::Delete.new("ajax/semilattice/machines/#{id}")
        @server.request(req)
      end

      def set_replica_settings(id, acks, replicas)
        post_data = {
          "replica_affinities" => {
            "00000000-0000-0000-0000-000000000000" => (replicas - 1)
          },
          "ack_expectations" => {
            "00000000-0000-0000-0000-000000000000" => {
              "expectation" => acks,
              "hard_durability" => true
            }
          }
        }
        req = Net::HTTP::Post.new("/ajax/semilattice/rdb_namespaces/#{id}")
        req['Content-Type'] = 'application/json'
        req.body = JSON.dump(post_data)
        @server.request(req)
      end

    end
  end
end
