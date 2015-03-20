
# ENV["RACK_ENV"] = "test"
require 'hashie/mash'
require 'whois'

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
    props = Hashie::Mash.new contact
    {
      available:    info.available?,
      name:         domain_name,
      name:         props && props.name,
      organization: props && props.organization,
      email:        props && props.email,
      phone:        props && props.phone,
      country:      props && props.country,
      ### TODO: resp.delete :raw
      raw:          "TODO",
    }
  end
end

p Whoiser.whois "github.it"
