
# ENV["RACK_ENV"] = "test"
require 'redis'
R = Redis.new

require 'hashie/mash'
require 'whois'
require 'securerandom'

class FakeWhois
  def self.whois(name)
    Hashie::Mash.new(
      name: name,
      available: true,
      email:     "ciccio@example.com",
      raw:       "blababla whois",
    )
  end
end

class Whoiser
  WHOIS = ENV["RACK_ENV"] == "test" ? FakeWhois : Whois

  def self.whois(domain_name)
    info = WHOIS.whois domain_name
    contact = info.admin_contact
    props = h contact
    result = h(
      available:    info.available?,
      name:         domain_name,
      contact_name: props && props.name,
      organization: props && props.organization,
      email:        props && props.email,
      phone:        props && props.phone,
      country:      props && props.country,
      ### TODO: resp.delete :raw
      raw:          "TODO",
    )

    store result
    result
  end

  def self.store(result)
    id = rand
    R.sadd  "domains", id
    R.mapped_hmset "domains:#{id}", result
  end

  def self.h(hash)
    Hashie::Mash.new hash
  end

  def self.rand
    SecureRandom.urlsafe_base64 15
  end

  def self.count
    R.keys.count
  end

end

# p Whoiser.whois "github.it"
# p Whoiser.count
