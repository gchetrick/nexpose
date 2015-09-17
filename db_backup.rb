#!/usr/bin/ruby
require 'nexpose'
include Nexpose

#Purpose of this is to run a scheduled DB backup job
#gch - 9/8/2015

nexpose_host = ''
username = ''
password = ''

nsc = Connection.new(nexpose_host, username, password)
nsc.login
active_scans = nsc.scan_activity

if active_scans.empty? 
    nsc.backup(plaform_independent = true)
end

nsc.logout
