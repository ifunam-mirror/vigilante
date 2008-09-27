ENV['RAILS_ENV'] ||= 'development'
#require '../config/environment.rb'
require '/home/juanger/vigilante/lib/video_builder'
include VideoTools

# Run this with each camera
# Use fork too
n = 10
puts Time.now.to_s
Camera.all.each do |camera|
  puts "#{camera.ip}"
  time = n.minutes.ago
  @video_builder = VideoTools::Builder.new(camera.ip, time.strftime("%Y/%m/%d"), "#{time.hour}:#{time.sec}")
  #video_output_path = "/var/video/#{camera.ip}/#{Date.today.strftime("%Y/%m/%d")}/#{time.hour}"
  video_output_path = "/var/video/#{camera.ip}"
  
  start_time = time.strftime("%Y-%m-%d-%H:%M")
  end_time = (time + n.minutes).strftime("%Y-%m-%d-%H:%M")
  filename = "#{start_time}_#{end_time}.avi"
  fork { @video_builder.encode(video_output_path + "/#{filename}") }# the forking video :)
  camera.videos << Video.new(:filename => filename, :path => video_output_path + "/#{filename}", :duration => n,  :start =>  time, :end => time + n.minutes )
end

p Process.waitall
