ENV['RAILS_ENV'] ||= 'development'
require '../config/environment.rb'
require '../lib/video_builder'
include Video

# Run this with each camera
# Use fork too
camera = Camera.last #do |camera|
  puts "#{camera.ip}"
  time = "17:50"
  @video_builder = Video::Builder.new(camera.ip, Date.today.strftime("%Y/%m/%d"), time)
  video_output_path = "/var/video/#{camera.ip}/#{Date.today.strftime("%Y/%m/%d")}/#{time.split(':').first}"
  @video_builder.encode(video_output_path + "/#{startend}-#{endtime}.avi")
  camera.videos << Video.new(:filename => filename, :path => 'path', :duration => n,  :start_datetime =>  timestamp, :end_datetime => timestamp )
#end
