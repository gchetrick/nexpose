#!/usr/bin/ruby
require 'nexpose'
require 'optparse'
include Nexpose

##Purpose is to see if a site currently has a scan running, if it does not then kick off a report.
##gch - 9/17/2015

#Set these to match your environment
nexpose_host = ''
username = ''
password = ''

parser = OptionParser.new do |opts|
opts.banner = "Usage: nexpose_scan.rb [options]"

opts.on("-i", "--id siteid",OptionParser::DecimalInteger, "Site ID") do |i|
  options[:id] = i;
  end
opts.on("-r", "--rid reportid",OptionParser::DecimalInteger, "Report ID") do |r|
  options[:rid] = r;
  end
end

parser.parse!

#create the connection and login
nsc = Connection.new(nexpose_host, username , password)
nsc.login
#grab scan activity
runningScans = nsc.scan_activity()
runningScans.each do |status|
  if options[:id] == status.site_id
    puts " Site ID: #{status.site_id}  Status #{status.status}"
  else
    reports = nsc.list_reports
    #uncomment to list all the reports with name and ID
    #reports.each do |report|
    #  puts "#{report.name} - #{report.config_id}"
    #end
    nsc.generate_report(options[:rid])
    puts "#{report.name} - #{report.config_id} has been started"
  end
end
nsc.logout
