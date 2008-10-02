# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  require 'yaml'
  require 'google_chart'
  
  def disk_usage
    config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "../../../tools/video_config.yml"))
    config["config"].each { |key, value| instance_variable_set("@#{key}", value) }
    
    pc = GoogleChart::PieChart.new('450x200', "Uso de disco", true)
    vid_usage = IO.popen("du -kd 0 #{@videos_path}").readlines.to_s.match(/([0-9.]+)[\t]/)[1].to_i
    img_usage = IO.popen("du -kd 0 #{@images_path}").readlines.to_s.match(/([0-9.]+)[\t]/)[1].to_i
    pc.data "Videos (#{IO.popen("du -hd 0 #{@videos_path}").readlines.to_s.match(/([0-9.]+\w)[\t]/)[1]})", vid_usage
    pc.data "Imágenes (#{IO.popen("du -hd 0 #{@images_path}").readlines.to_s.match(/([0-9.]+\w)[\t]/)[1]})", img_usage
    pc.data "Libre", @total_space - (vid_usage + img_usage)
    pc.to_url
  end
  
end
