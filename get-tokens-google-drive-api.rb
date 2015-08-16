# encoding: utf-8
require 'rubygems'
require 'yaml'
require "google/api_client"
require 'google_drive'

config_secret = YAML.load_file(File.join(ENV['HOME'], '.check-servers2', 'config-secret.yml'))
tokens = YAML.load_file(File.join(ENV['HOME'], '.check-servers2', 'tokens.yml'))

client = Google::APIClient.new(
  :application_name => 'Check Servers',
  :application_version => '0.0.1'
)

auth = client.authorization
auth.client_id = config_secret['client_id']
auth.client_secret = config_secret['client_secret']
auth.scope =
    "https://docs.google.com/feeds/" +
    "https://www.googleapis.com/auth/drive " +
    "https://spreadsheets.google.com/feeds/"
auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"

print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
print("2. Enter the authorization code shown in the page: ")

auth.code = $stdin.gets.chomp
auth.fetch_access_token!

system'clear'
puts "access_token: #{auth.access_token}"
puts "refresh_token: #{auth.refresh_token }"
print "\n"

tokens['access_token'] = auth.access_token
tokens['refresh_token'] = auth.refresh_token
File.open(ENV['HOME'] + '/.check-servers2/' + 'tokens.yml', 'w') { |f| YAML.dump(tokens, f) }

puts 'tokens atualizados'
print "\n"
