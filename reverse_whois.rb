require_relative "../config/env"

class ReverseWhois
  get "/" do
    haml :index
  end

  post "/whois" do
    domains = Parser.parse params[:domains]

    domains.each do |domain|
      WhoisJob.async.perform
    end

    "done!"
  end
end
