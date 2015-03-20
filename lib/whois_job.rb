class WhoisJob
  include SuckerPunch::Job

  def perform(domain)
    Whoiser.whois domain
  end
end

# WhoisJob.async.perform
