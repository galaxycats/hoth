class Exception
  def to_json(*params)
    as_json(*params).to_json(*params)
  end

  def as_json(*params)
    {
      'json_class'   => self.class.name,
      'message'      => self.message,
      'backtrace'    => self.backtrace
    }
  end

  def self.json_create(hash)
    exception = new(hash["message"])
    exception.set_backtrace hash['backtrace']
    exception
  end
end
