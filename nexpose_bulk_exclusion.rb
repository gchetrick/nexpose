#!/usr/bin/ruby
require 'nexpose'
require 'optparse'
include Nexpose

#The purpose for this is to grab a list of assets from an asset group and apply an exclusion to them.
#gch - 1/14/2016

nexpose_host = ''
username = ''
password = ''

options = {:agroup => nil}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: nexpose_scan.rb [options]"

  opts.on("-k", "--VulnKey KEY", "Vulnerability numeric key") do |k|
    options[:vulnkey] = k;
  end
  opts.on("-i", "--VulnID ID", "Vulnerability ID") do |i|
    options[:vulnid] = i;
  end
  opts.on("-r", "--reason EXCLUSION", "Reason for exclusion (Compensating Control, False Positive, Acceptable Use, Acceptable Risk, Other") do |r|
    options[:reason] = r;
  end
  opts.on("-c", "--comment COMMENT", "Comment for the exclusion") do |c|
    options[:comment] = c;
  end
  #opts.on("-a", "--approve", "Approve exception after saving")
  opts.on("-g", "--agroup ASSETGROUP", "Asset Group name") do |g|
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

devices = group.devices.map { |dev| dev.id }.uniq  
devices.each do |asset|  
  begin  
    vulns = nsc.list_device_vulns(asset)  
  rescue  
    puts "Asset does not exist: Failed to add exception for Asset Address: #{asset} Vuln ID: '#{options[:vulnid]}'."  
    next  
  end  
  vuln = vulns.select { |finding| finding.id == options[:vulnid] }.first  
  unless vuln  
    puts "Asset Vulnerability does not exist: Failed to add exception for Asset Address: #{asset} Vuln ID: '#{options[:vulnid]}'."  
    next  
  end  
  vuln_exception = VulnException.new(vuln.id, VulnException::Scope::SPECIFIC_INSTANCE_OF_SPECIFIC_ASSET, options[:reason])
  vuln_exception.asset_id = asset
  vuln_exception.vuln_key = options[:vulnkey]
  vuln_exception.save(nsc, options[:comment])
   vuln_exception.approve(nsc); # If you want to submit and approve uncomment this line.  
end
nsc.logout
