class Video < ActiveRecord::Base
  belongs_to :camera
  
  def self.search_with_paginate(options, page=1, per_page=10)
    options.keys.each do |k|
       options.delete k if options[k].nil? or options[k].to_s.strip.empty?
    end
    paginate(:all, :conditions => options,
             :select => 'videos.*',
             :joins => "LEFT JOIN cameras ON videos.camera_id = cameras.id",
             # :order => 'people.lastname1 ASC, people.lastname2 ASC, people.firstname ASC',
             :page => page, :per_page => per_page)
  end
end
