#!/usr/bin/ruby
require 'nexpose'
require 'optparse'
include Nexpose

##Purpose of this is to run a rescan of created asset group
##gch - 9/9/2015

#Set these to match your environment
nexpose_host ''
username = ''
password = ''

options = {:agroup => nil}

parser = OptionParser.new do |opts|
opts.banner = "Usage: nexpose_scan.rb [options]"

opts.on("-i", "--id siteid",OptionParser::DecimalInteger, "Site ID") do |i|
  options[:id] = i;
  end
end

parser.parse!

nsc = Connection.new(nexpose_host, username , password)
nsc.login
runningScans = nsc.scan_activity()
runningScans.each do |status|
  if options[:id] == status.site_id
    puts " Site ID: #{status.site_id}  Status #{status.status}"
  end
end
nsc.logout
