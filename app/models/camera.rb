require 'cronedit'

class Camera < ActiveRecord::Base
  has_many :videos
  belongs_to :quality
  belongs_to :codec
  belongs_to :agent
  
  # Callbacks
  after_save :edit_crontab
  
  # this will edit the crontab to add or edit a task
  def edit_crontab
    ct = CronEdit::Crontab.new 
    # cameras don't have a duration for their videos now    
    ct.add self.ip, {:minute => "*/#{self.video_duration}",
                     :command => "#{RAILS_ROOT}/tools/video_recorder.rb #{self.ip}" }
    ct.commit
  end
end
