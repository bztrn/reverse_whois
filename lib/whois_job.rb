class WhoisJob
  include SuckerPunch::Job

  def perform(event)
    Whoiser.new(event).whois
  end
end
