class Exception
  def to_json(*params)
    {
      'json_class'   => self.class.name,
      'message'      => self.message,
      'backtrace'    => self.backtrace
    }.to_json(*params)
  end
  
  def self.json_create(hash)
    exception = new(hash["message"])
    exception.set_backtrace hash['backtrace']
    exception
  end
end