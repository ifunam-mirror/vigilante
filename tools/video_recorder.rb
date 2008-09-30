#!/usr/bin/env /home/vigilante/vigilante/script/runner

require File.expand_path(File.dirname(__FILE__) + "/../lib/video_builder")
require 'yaml'
include VideoTools

module VideoRecorder

  def self.record(ip,start_time=Time.now)
    self.read_config
    camera = Camera.find_by_ip(ip)
    n = camera.video_duration
    
    @@video_builder = VideoTools::Builder.new(@@images_path, camera.ip,
                                    start_time.strftime("%Y/%m/%d"),
                                    "#{start_time.hour}:#{start_time.sec}",
                                    n)
                                    
    video_output_path = File.join(@@videos_path,camera.ip,start_time.strftime("%Y/%m/%d/%H"))
    
    begin
      File.stat video_output_path
    rescue
      FileUtils.mkdir_p video_output_path
    end

    filename = "#{start_time.hour}:#{start_time.sec}"
    fork { @@video_builder.encode(File.join(video_output_path, "/#{filename}.avi")) }# the forking video :)
    camera.videos << Video.new(:filename => filename,
                               :path => File.join(video_output_path, "#{filename}.avi"),
                               :start =>  start_time,
                               :end =>  n.minutes.since(start_time),
                               :thumbnail =>  File.join(video_output_path, "#{filename}.jpg"))
  end

  private
  
  def self.read_config
    config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/video_config.yml"))
    config["config"].each { |key, value| class_variable_set("@@#{key}", value) }
  end
  
end

# This will be called by cron with something like:
# */#{camera.duration} * * * * username /usr/bin/env ruby /vigilante/path/script/runner /vigilante/path/tools/video_recorder #{camera.ip}
puts Time.now.to_s
VideoRecorder.record(ARGV[0])
