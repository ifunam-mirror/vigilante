require File.expand_path(File.dirname(__FILE__) + "/../../lib/time_extensions")
require 'test_helper'

class TimeExtensionsTest < Test::Unit::TestCase
  def test_should_return_successors_in_minutes
    now = Time.now
    assert_equal(now + 60.seconds, now.succ)
  end
  
  def test_should_return_seconds_in_seconds
    assert_equal 40, 40.seconds
  end
  
  def test_should_return_minutes_in_seconds
    assert_equal 300, 5.minutes
  end
  
  def test_should_return_hours_in_seconds
    assert_equal 10800, 3.hours
  end
  
  def test_should_return_days_in_seconds
    assert_equal 172800, 2.days
  end
  
  def test_should_return_time_ago
    # It may fail if you run it at 00 hours
    three_days = 259200    
    assert_equal (Time.now - three_days).to_s, (3.days.ago).to_s
  end
end