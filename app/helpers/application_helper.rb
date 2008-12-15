# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  require 'yaml'
  require 'google_chart'
  
  def disk_usage_chart
    config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "../../../tools/video_config.yml"))
    config["config"].each { |key, value| instance_variable_set("@#{key}", value) }

    chart = GoogleChart::PieChart.new(:width => 500, :height => 200, :is_3d => true)
    
    Camera.all.each do |camera|
      chart.data camera.ip, camera.disk_usage
    end
    
    chart.data "Libre", available_space , 'dddddd' # We need the available space...
    chart.to_url
  end
  
  def available_space
    `df #{@videos_path} | awk '{ print $4 }' | tail -1`.to_i
  end

  def humanize(blocks, block_size = 512)
    number_to_human_size(blocks*block_size)
  end
  
end
