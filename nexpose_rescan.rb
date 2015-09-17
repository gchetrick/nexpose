#!/usr/bin/ruby
require 'nexpose'
require 'optparse'
include Nexpose

#Purpose of this is to run a rescan of created asset group
#gch - 9/9/2015

nexpose_host = ''
username = ''
password = ''

options = {:agroup => nil}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: nexpose_scan.rb [options]"

  opts.on("-g", "--agroup assetgroup", "Asset Group name") do |g|
    options[:agroup] = g;
  end
end

parser.parse!

nsc = Connection.new(nexpose_host, username , password)
nsc.login

scan_group = nsc.asset_groups.find { |group| group.name == options[:agroup] }

if !scan_group
  puts "Scan group not found"
  nsc.logout
  exit
end

group = AssetGroup.load(nsc, scan_group.id)
group.rescan_assets(nsc)

nsc.logout
