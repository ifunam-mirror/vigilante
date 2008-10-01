require 'rubygems'
require 'rtranscoder/mencoder'
require 'rtranscoder/ffmpeg'
require File.expand_path(File.dirname(__FILE__) + "/../lib/video_frame_dir")

module VideoTools
  class Builder
    include RTranscoder
    
    def initialize(frames_path, dir, date, hour, length=10.minutes, frame_type="jpg")
      @frames_dir = VideoFrameDir.new(File.join(frames_path,dir))
      @date = date
      @hour = hour
      @length = length
      @frame_type = frame_type
    end

    # mencoder mf://frame001.jpg,frame002.jpg -mf w=800:h=600:fps=2:type=jpg
    # -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o output.avi
    def encode(file="output.avi")
      puts "encoding video #{file}"
      MEncoder.encode do |mencoder|
        mencoder.input = "mf://#{@frames_dir.file_list(@date, @hour, @length, @frame_type).join(',')}"
        mencoder.mf.fps = 2
        mencoder.mf.type = "jpg"
        mencoder.output_video_codec = :lavc
        mencoder.lavc.vcodec = "mpeg4"
        mencoder.lavc.mbd = 2
        mencoder.lavc.trell = true
        mencoder.output_audio_codec = 'copy'
        mencoder.output = file
      end
    end
    
    # ffmpeg -i video -t 0.001 -ss 0 -vframes 1 -f mjpeg -s 320x240 thumbnail.jpg
    def get_thumbnail(input)
      puts "getting thumbnail of #{input}"
      out = File.join(File.dirname(input),File.basename(input,File.extname(input)) + ".jpg")
      RTranscoder.thumbnail(:video => input,
                            :start => '00:00:00',
                            :length => '00:00:01',
                            :frames => 1,
                            :width => 320,
                            :height => 240,
                            :image => out)
    end

  end
end
