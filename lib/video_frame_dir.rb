require 'time_extensions'

class VideoFrameDir
  attr_reader :dirs
  
  def initialize(frames_path)
    @frames_path = frames_path
  end

  def file_list(date, hour, length=10.minutes, extension="jpg")
    first = Time.parse("#{date} #{hour}")
    last = first + length
    self.directories time_range(first,last)
    self.search_files extension
  end
  
  #private
  
  def search_files(extension)
    @dirs.collect do |dir| 
      Dir.glob(File.join(@frames_path, dir, "*.#{extension}")).collect { |f| f }
    end.flatten
  end

  def directories(dirs)
    @dirs = dirs.collect { |dir| dir if FileTest.directory? File.join(@frames_path,dir) }.compact
  end
  
  def time_range(first, last)
    (first..last).collect { |min| min.strftime("%Y/%m/%d/%H/%M") }
  end
  
end