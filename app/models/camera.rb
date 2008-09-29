# require 'cronedit'

class Camera < ActiveRecord::Base
  has_many :videos
  belongs_to :quality
  belongs_to :codec
  belongs_to :agent
  
  # Callbacks
  #after_save :edit_crontab
  
  # this will edit the crontab to add or edit a task
  def edit_crontab
    ct = CronEdit::Crontab.new 'root'
    # cameras don't have a duration for their videos now    
    ct.add this.ip, {:minute => "*/#{this.duration}",
                     :command => "/usr/bin/env ruby #{RAILS_ROOT}/script/runner " +
                                "#{RAILS_ROOT}/tools/video_recorder #{this.ip}" }
    ct.commit
  end
end
