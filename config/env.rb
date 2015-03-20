require 'bundler/setup'
Bundler.require :default

path = File.expand_path "../../", __FILE__
PATH = path

require "#{path}/lib/whois_job"
require "#{path}/lib/parser"
require "#{path}/lib/query"
require "#{path}/lib/whoiser"

# begin
R = Redis.new
# rescue connecterror
# continuing without persistence (redis)
#
