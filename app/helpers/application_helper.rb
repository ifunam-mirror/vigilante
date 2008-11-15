# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  require 'yaml'
  # require 'google_chart'
  
  def disk_usage
    config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "../../../tools/video_config.yml"))
    config["config"].each { |key, value| instance_variable_set("@#{key}", value) }
    
    pattern = /[.\d\w]+\s+([.\d\w]+)\s+([.\d\w]+)\s+([.\d\w]+)/
    usage = {}
    
    df = IO.popen("df #{@videos_path} #{@images_path}").readlines
    videos_usage = df[1].match(pattern)
    images_usage = df[2].match(pattern)
    
    usage[:videos] = videos_usage[2].to_i
    usage[:images] = images_usage[2].to_i

    usage[:free] = videos_usage[3].to_i + images_usage[3].to_i
    pc = GoogleChart::PieChart.new('500x200', "", true)
    
    pc.data "Images", usage[:images], '00ff00'
    pc.data "Videos", usage[:videos], 'ff8800'
    pc.data "Libre", usage[:free], 'dddddd'
    pc.to_url
  end
  
end
