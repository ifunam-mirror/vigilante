# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  require 'yaml'
  require 'google_chart'
  require 'digest'
  
  def disk_usage_chart
    config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "../../../tools/video_config.yml"))
    config["config"].each { |key, value| instance_variable_set("@#{key}", value) }

    chart = GoogleChart::PieChart.new(:width => 500, :height => 200, :is_3d => true)
    
    Camera.all.each do |camera|
      chart.data camera.ip, camera.disk_usage, camera.color
    end
    
    chart.data "Libre", available_space , 'dddddd'
    chart.to_url
  end
  
  def available_space
    `df -b #{@videos_path} | awk '{ print $4 }' | tail -1`.to_i * 512
  end
  
  def display_markers(map)
    Camera.all.each do |camera|
      description = link_to('Edit', edit_camera_path(1))
      videos = link_to('Videos', camera_videos_path(1))
      info = "#{camera.location}<br/>IP: #{camera.ip}<br/>"+ 
             "#{link_to 'Videos', camera_videos_path(camera)}"
      map.overlay_init(GMarker.new([camera.lat.to_f, camera.lng.to_f], :info_window => info))
    end
  end
  
end
