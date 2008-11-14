require 'cronedit'

class Camera < ActiveRecord::Base
  validates_presence_of :ip, :location, :codec_id, :agent_id, :quality_id
  validates_numericality_of :id, :greater_than => 0, :only_integer => true, :allow_nil => true
  validates_numericality_of :codec_id, :agent_id, :quality_id, :greater_than => 0, :only_integer => true

  validates_format_of   :ip, :with => /(\d{1,3}\.){3}\d{1,3}/ 
  
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
