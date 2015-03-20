
class Query

  def self.all
    ids = R.smembers "domains"
    ids.map do |id|
      R.hgetall "domains:#{id}"
    end
  end

end
