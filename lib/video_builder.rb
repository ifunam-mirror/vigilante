require 'rubygems'
require 'rtranscoder/mencoder'
require 'video_frame_dir'

module Video
  class Builder
    include RTranscoder

    # FRAMES_PATH = RAILS_ROOT + '/tmp'
    FRAMES_PATH = '/Users/alex/Projects/rails/vigilante/tmp'

    def initialize(dir, date, hour, length=10.minutes, frame_type="jpg")
      @frames_dir = VideoFrameDir.new(File.join(FRAMES_PATH,dir))
      @date = date
      @hour = hour
      @length = length
      @frame_type = frame_type
    end

    # mencoder mf://frame001.jpg,frame002.jpg -mf w=800:h=600:fps=25:type=jpg
    # -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o output.avi
    def encode(file="output.avi")
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

  end
end

