#!/usr/bin/env /var/vigilante/script/runner

require File.expand_path(File.dirname(__FILE__) + "/../lib/video_builder")
require 'yaml'
require 'ftools'
include VideoTools

module VideoRecorder

  def self.record(ip,end_time=Time.now)
    self.read_config
    camera = Camera.find_by_ip(ip)
    n = camera.video_duration
    
    end_time = Time.parse(end_time) if end_time.is_a? String
    
    start_time = end_time - n.minutes
    time = start_time.strftime("%H%M")
    puts "start: #{time}"
    
    @@video_builder = VideoTools::Builder.new(@@images_path,
                                    camera.ip,
                                    start_time.strftime("%Y/%m/%d"),
                                    start_time.strftime("%H:%M"),
                                    n.minutes)
    puts "#{n}, #{@@images_path}"


    # Build video and thumbnail
    video_temp = File.join(@@video_tmp_path, "#{camera.ip}-#{start_time.strftime("%Y-%m-%d-%H")}.avi")
    thumb_temp = File.join(@@video_tmp_path, "#{camera.ip}-#{start_time.strftime("%Y-%m-%d-%H")}-1.jpg")
    @@video_builder.encode(video_temp)
    @@video_builder.get_thumbnail(video_temp)

    blocks_needed = File.size(video_temp) + File.size(thumb_temp)
    blocks_available = `df #{@@videos_path} | awk '{ print $4 }' | tail -1`.to_i
    
    Video.all(:order => 'start', :limit => 60/n).destroy if blocks_available < blocks_needed
    
    video_path = File.join(@@videos_path,camera.ip,start_time.strftime("%Y/%m/%d/%H"))

    FileUtils.mkdir_p video_path unless File.directory? video_path

    File.move video_temp, File.join(video_path, "#{time}.avi")
    File.move thumb_temp, File.join(video_path, "#{time}.jpg")
    
    # Erase images files
    @@video_builder.erase_source_images
    
    # Save video on DB
    camera.videos << Video.new(:filename => time,
                               :path => File.join(video_path, "#{time}.avi"),
                               :start =>  start_time,
                               :end =>  n.minutes.since(start_time),
                               :thumbnail =>  File.join(video_path, "#{time}.jpg"))
  end

  private
  
  def self.read_config
    config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/video_config.yml"))
    config["config"].each { |key, value| class_variable_set("@@#{key}", value) }
  end
  
end

# This will be called by cron with something like:
# */#{camera.duration} * * * * /vigilante/path/tools/video_recorder #{camera.ip}
puts Time.now.to_s
VideoRecorder.record(ARGV[0], ARGV[1] || Time.now)
