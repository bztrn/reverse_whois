# domains list parser

class Parser

  def self.parse(domains)
    new(domains).parse
  end

  attr_reader :domains

  def initialize(domains)
    @domains = domains
  end

  def parse
    domains.split(/\n/).map &:strip
  end

end
