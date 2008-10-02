require 'cronedit'

class Camera < ActiveRecord::Base
  has_many :videos
  belongs_to :quality
  belongs_to :codec
  belongs_to :agent
  
  # Callbacks
  after_save :add_task_to_crontab
  
  
  # this will edit the crontab to add or edit a task
  def add_task_to_crontab
    ct = CronEdit::Crontab.new 
    ct.add self.ip, {:minute => "*/#{self.video_duration}",
                     :command => "#{RAILS_ROOT}/tools/video_recorder.rb #{self.ip}" }
    ct.commit
  end
  
  def remove_task_from_crontab
    ct = CronEdit::Crontab.new 
    ct.remove self.ip
    ct.commit
  end
end
