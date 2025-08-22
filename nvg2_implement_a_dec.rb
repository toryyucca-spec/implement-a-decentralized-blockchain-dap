require 'json'
require 'httparty'

class DecentralizedDAppTracker
  attr_accessor :dapp_list, :blockchain_client

  def initialize
    @dapp_list = []
    @blockchain_client = HTTParty
  end

  def add_dapp(name, address)
    @dapp_list << { name: name, address: address }
  end

  def track_dapp(dapp_name)
    dapp = @dapp_list.find { |dapp| dapp[:name] == dapp_name }
    return "DApp not found" if dapp.nil?

    response = @blockchain_client.get("https://api.etherscan.io/api?module=account&action=txlist&address=#{dapp[:address]}")
    tx_list = JSON.parse(response.body)['result']

    tx_list.each do |tx|
      puts "DApp #{dapp_name} transaction: #{tx['hash']}"
    end
  end
end

# Test case
tracker = DecentralizedDAppTracker.new
tracker.add_dapp('MyDApp', '0x742d35Cc6634C0532925a3b844Bc454e4438f44e')
tracker.track_dapp('MyDApp')