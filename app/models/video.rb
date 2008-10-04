class Video < ActiveRecord::Base
  belongs_to :camera
  
  def self.search_with_paginate(options, page=1, per_page=10)
    options.keys.each do |k|
       options.delete k if options[k].nil? or options[k].to_s.strip.empty?
    end
    
    conditions = [""]
    
    if options[:camera_id]
      conditions[0] += "videos.camera_id = ? "
      conditions << options[:camera_id]
    end
    
    if options[:start]
      conditions[0] += "#{"AND" if conditions[0].size > 0} videos.start >= datetime(?) "
      conditions << Time.parse(options[:start]).strftime("%Y-%m-%d %H:%M")
    end
    
    if options[:end]
      conditions[0] += "#{"AND" if conditions[0].size > 0} videos.end <= datetime(?) "
      conditions << Time.parse(options[:end]).strftime("%Y-%m-%d %H:%M")
    end
    
    paginate(:all, 
             :conditions => conditions,
             :select => 'videos.*',
             :joins => "LEFT JOIN cameras ON videos.camera_id = cameras.id",
             :order => 'videos.start ASC',
             :page => page,
             :per_page => per_page)
  end
  
  def duration
    d = (self.end - self.start)/60
    d.to_i
  end
end
