require_relative "config/env"
require 'json'

class ReverseWhois < Sinatra::Base
  get "/" do
    haml :index
  end

  post "/whois" do
    domains = Parser.parse params[:domains]

    domains.each do |domain|
      WhoisJob.new.async.perform domain
    end

    "done!"
  end

  get "/domains" do
    Query.all.to_json
  end
end
