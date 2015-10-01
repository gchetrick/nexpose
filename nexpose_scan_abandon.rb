#!/usr/bin/ruby
require 'nexpose'
require 'optparse'
include Nexpose

#Purpose of this is to run a rescan of created asset group
#gch - 10/1/2015

nexpose_host = ''
username = ''
password = ''
group_id = 1

#options = {:agroup => nil}

#parser = OptionParser.new do |opts|
#  opts.banner = "Usage: nexpose_scan.rb [options]"
#
#  opts.on("-g", "--agroup assetgroup", "Asset Group name") do |g|
#    options[:agroup] = g;
#  end
#end

#parser.parse!

nsc = Connection.new(nexpose_host, username , password)
nsc.login

group = AssetGroup.load(nsc, group_id)
name = "#{group.name} Assets"
site = Site.new(name)
site.description = group.description
site.engine = 5
devices = group.devices.map { |dev| dev.address }.uniq
devices.each do |asset|
  site.add_asset(asset)
end

site.save(nsc)
puts "Saved new site: #{name}"

group.rescan_assets(nsc)

nsc.logout
