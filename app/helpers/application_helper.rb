# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  require 'yaml'
  require 'google_chart'
  
  def disk_usage_chart
    config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "../../../tools/video_config.yml"))
    config["config"].each { |key, value| instance_variable_set("@#{key}", value) }
    # 
    # pattern = /[.\d\w]+\s+([.\d\w]+)\s+([.\d\w]+)\s+([.\d\w]+)/
    # usage = {}
    # 
    # df = IO.popen("df #{@videos_path}").readlines
    # videos_usage = df[1].match(pattern)
    # images_usage = df[2].match(pattern)
    # 
    # usage[:videos] = videos_usage[2].to_i
    # usage[:images] = images_usage[2].to_i
    # 
    # usage[:free] = videos_usage[3].to_i + images_usage[3].to_i

    chart = GoogleChart::PieChart.new('500x300', "", true)
    
    Camera.all.each do |camera|
      chart.data camera.ip, camera.disk_usage
    end
    
    #pc.data "Libre", `df #{@videos_path} | awk '{ print $4 }' | tail -1`.to_i , 'dddddd' # We need the available space...
    pc.to_url
    
  end
  
end
