#!/usr/bin/env /home/vigilante/vigilante/script/runner

require File.expand_path(File.dirname(__FILE__) + "/../lib/video_builder")
require 'yaml'
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
    
    @@video_builder = VideoTools::Builder.new(@@images_path, camera.ip,
                                    start_time.strftime("%Y/%m/%d"),
                                    time,
                                    n.minutes)
                                    
    video_output_path = File.join(@@videos_path,camera.ip,start_time.strftime("%Y/%m/%d/%H"))
    
    begin
      File.stat video_output_path
    rescue
      FileUtils.mkdir_p video_output_path
    end

    @@video_builder.encode(File.join(video_output_path, "#{time}.avi"))
    @@video_builder.get_thumbnail(File.join(video_output_path, "#{time}.avi"))
    
    camera.videos << Video.new(:filename => time,
                               :path => File.join(video_output_path, "#{time}.avi"),
                               :start =>  start_time,
                               :end =>  n.minutes.since(start_time),
                               :thumbnail =>  File.join(video_output_path, "#{time}-1.jpg"))
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
