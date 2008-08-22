require 'time'

class Time
  def succ
    self + 1.minute
  end
end


class Numeric
  
  def seconds
    self
  end
  alias :second :seconds
  
  def minutes
    self*60
  end
  alias :minute :minutes
  
  def hours
    self.minutes*60
  end
  alias :hour :hours
  
  def days
    self.hours*24
  end
  alias :day :days
  
  def ago
    Time.now - self
  end
end