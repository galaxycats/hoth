require 'active_support'

class StatisticsObject
  attr_accessor :id, :owner_id, :statistic_type, :timestamp, :group_condition
  
  def initialize(attributes)
    @id              = attributes[:id]
    @owner_id        = attributes[:owner_id]
    @statistic_type  = attributes[:statistic_type]
    @timestamp       = attributes[:timestamp]
    @group_condition = attributes[:group_condition]
  end
  
  def self.json_create(hash)
    new(hash.symbolize_keys)
  end
end

class Event
  attr_accessor :name, :count

  def initialize(attributes)
    @name  = attributes[:name]
    @count = attributes[:count]
  end

  def self.json_create(hash)
    new(hash.symbolize_keys)
  end
end

class StatisticData
  attr_accessor :events, :original_id
  
  def initialize(attributes)
    @events      = attributes[:events]
    @original_id = attributes[:original_id]
  end

  def self.json_create(hash)
    new(hash.symbolize_keys)
  end
end

class Account
  attr_accessor :firstname, :lastname, :contract, :company
  
  def initialize(attributes)
    @firstname = attributes[:firstname]
    @lastname  = attributes[:lastname]
    @contract  = attributes[:contract]
    @company   = attributes[:company]
    @contract
  end
  
  def to_serialize
    [:firstname, :lastname, :contract, :company]
  end
  
end
