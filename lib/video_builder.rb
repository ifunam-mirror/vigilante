require 'rubygems'
require 'rtranscoder/mencoder'
require 'time_range'

module Video
  module Builder
    include RTranscoder
    
    FRAMES_PATH = "../tmp"

    # mencoder mf://frame001.jpg,frame002.jpg -mf w=800:h=600:fps=25:type=jpg
    # -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o output.avi
    def encode(files)
      MEncoder.encode do |mencoder|
        mencoder.input = "mf://#{files.join(',')}"
        mencoder.mf.fps = 25
        mencoder.mf.type = "jpg"
        mencoder.output_video_codec = :lavc
        mencoder.lavc.vcodec = "mpeg4"
        mencoder.lavc.mbd = 2
        mencoder.lavc.trell = true
        mencoder.output_audio_codec = 'copy'

        mencoder.output = "../tmp/output.avi"
      end
    end

    def files(dirs)
      dirs.collect do |dir| 
        Dir.glob("#{dir}/*.jpg").collect { |f| f }    
      end.flatten
    end

    def directories(dirs)
      dirs.collect { |dir| dir if FileTest.directory? dir }.compact
    end

    def frames(ip, date, hour, length=10.minutes)
      first = Time.parse("#{date} #{hour}")
      last = first + length
      files(directories((first..last).collect do |min| 
          File.join(FRAMES_PATH, ip, min.strftime("%Y/%m/%d/%H/%M")) 
        end))
    end

  end
end

include Video::Builder
  
    def test_get_files
      encode(frames("192.168.200.165", "2008/05/28", "18:00", 10.minutes))
    end

puts test_get_files