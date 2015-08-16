# encoding: utf-8
require 'rubygems'
require 'yaml'
require "google/api_client"
require 'google_drive'
require_relative 'lib/check/connection'

def decode_column_number(column_char)
    (column_char.upcase.ord - "A".ord) + 1
end

def print_usage
    puts """
Use:
  ruby check-servers.rb
"""
    exit(0)
end

def check_connections_range(ip_value, ports_range, ports_range_separator)
  result = false
  for port_element in ports_range.split(ports_range_separator)
    port_element = port_element.strip
    connection = Check::Connection.new(ip_value, port_element)
    result = connection.open?
    puts "#{ip_value}:#{port_element} => #{result}"
    break if result == false
  end
  result
end

def check_connections(ip_value, ports, ports_separator, ports_range_separator)
  result = false
  for ports_range in ports.split(ports_separator)
    ports_range = ports_range.strip
    result = check_connections_range(ip_value, ports_range, ports_range_separator)
    break if result == false
  end
  result
end

config = YAML.load_file(File.join(ENV['HOME'], '.check-servers2', 'config.yml'))
config_secret = YAML.load_file(File.join(ENV['HOME'], '.check-servers2', 'config-secret.yml'))
tokens = YAML.load_file(File.join(ENV['HOME'], '.check-servers2', 'tokens.yml'))

client = Google::APIClient.new(
  :application_name => 'Check Servers',
  :application_version => '0.0.1'
)

auth = client.authorization
auth.client_id = config_secret['client_id']
auth.client_secret = config_secret['client_secret']

session = GoogleDrive.login_with_oauth(tokens['access_token'])

ws = session.spreadsheet_by_key(config['document_key']).worksheets[config['worksheet_index'].to_i]

server_column=decode_column_number(config['server_column'])
ip_column=decode_column_number(config['ip_column'])
port_column=decode_column_number(config['port_column'])
date_column=decode_column_number(config['date_column'])
result_column=decode_column_number(config['result_column'])
result_detail_column=decode_column_number(config['result_detail_column'])

puts "Updating worksheet: #{ws.inspect}"

for row in config['start_from_row'].to_i..ws.num_rows
  current_time = Time.now.strftime '%Y/%m/%d %H:%M:%S'

  ip_value = ws[row, ip_column].strip
  port_value = ws[row, port_column].strip

  result = false
  if (ip_value != "")
    result = check_connections(ip_value, port_value, config['ports_separator'], config['ports_range_separator'])
  end

  ws[row, date_column] = current_time
  ws[row, result_column] = result ? "OK" : "FALHA"

end

ws.save
