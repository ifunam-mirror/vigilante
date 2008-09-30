module Factory
  def self.included(base)
    base.extend(self)
  end
  
  def build_valid(params = {})
    unless self.respond_to?("builder_#{self.name.underscore}")
      raise "There are no default params for #{self.name}"
    end
    obj = new(self.send("builder_#{self.name.underscore}", params))
    obj.save
    obj
  end

  def build_valid!(params = {})
    obj = build_valid(params)
    obj.save!
    obj
  end

  def builder_user(params)
    { :login => 'robert', 
      :password => 'supersecret', 
      :password_confirmation => 'supersecret', 
      :email => 'alex@fisica.unam.mx'
    }.merge(params)
  end

  def builder_period(params)
    { :name => '2010-1', 
      :start_date => '2009/08/10',
      :end_date => '2009/12/25',
    }.merge(params)
  end

  def builder_course(params)
    { :title => 'Operating Systems', 
      :description => 'Estudiaremos sistemas operativos',
      :references => 'Modern Operating Systems, Andrew S. Tanenbaum, 2nd Edition',
      :url => 'http://groups.google.com.mx/group/os-classroom/'
    }.merge(params)
  end
  
  def builder_homework(params)
    { :name => 'Homework3',
      :start_date => '2008/08/08',
      :end_date => '2008/12/08', 
      :url => 'http://someplace.com/homework3',
      :course_id => Course.first.id
    }
  end

end

ActiveRecord::Base.class_eval do
  include Factory
end
