#!/usr/bin/ruby
require 'nexpose'
include Nexpose
#Create a connection to the Nexpose instance and log in.
nsc = Nexpose::Connection.new('host', 'username', 'password', 3780)
nsc.login

#query = 'select asset_id from dim_asset where host_name like \'MGC577\''

#reporting_config = Nexpose::AdhocReportConfig.new(nil, 'sql')
#report_config.add_filter('query', query)
#report_output = report_config.generate(nsc)
#
assets = nsc.filter(Search::Field::ASSET, Search::Operator::CONTAINS, 'asset')
assets.each { |asset| id = asset.id }

# Create the tag
tag = Nexpose::Tag.new("ManagedTesting", Nexpose::Tag::Type::Generic::CUSTOM)
tag.add_to_asset(nsc,id)
