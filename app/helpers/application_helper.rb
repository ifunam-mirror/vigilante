# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  require 'yaml'
  require 'google_chart'
  
  def disk_usage
    config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "../../../tools/video_config.yml"))
    config["config"].each { |key, value| instance_variable_set("@#{key}", value) }
    
    pattern = /[.\d\w]+\s+([.\d\w]+)\s+([.\d\w]+)\s+([.\d\w]+)/
    
    block_usage = IO.popen("df #{@videos_path}").readlines[1].match(pattern)
    mem_usage = IO.popen("df -h #{@videos_path}").readlines[1].match(pattern)
    
    pc = GoogleChart::PieChart.new('500x200', "", true)
    
    pc.data "Usado (#{mem_usage[2]})", block_usage[2].to_i, 'ff8800'
    pc.data "Libre (#{mem_usage[3]})", block_usage[3].to_i, 'dddddd'
    pc.to_url
  end
  
end
