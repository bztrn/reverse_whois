require_relative "../config/env"

class ReverseWhois
  get "/" do
    haml :index
  end
end
