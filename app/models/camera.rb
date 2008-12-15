require 'cronedit'

class Camera < ActiveRecord::Base
  validates_presence_of :ip, :location, :codec_id, :agent_id, :quality_id
  validates_numericality_of :id, :greater_than => 0, :only_integer => true, :allow_nil => true
  validates_numericality_of :codec_id, :agent_id, :quality_id, :greater_than => 0, :only_integer => true

  validates_format_of :ip, :with => /(\d{1,3}\.){3}\d{1,3}/ 
  
  has_many :videos
  belongs_to :quality
  belongs_to :codec
  belongs_to :agent
  
  # Callbacks
  after_save :add_task_to_crontab
  after_destroy :remove_task_from_crontab
  
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
  
  def disk_usage
    Video.sum('files_size', :conditions => ['camera_id = ?', self.id])
  end
  
  def newest_video_date
    Video.last(:conditions => ['camera_id = ?', self.id]).start
  end
  
  def oldest_video_date
    Video.first(:conditions => ['camera_id = ?', self.id]).start
  end
  
  def self.disk_usage
    Video.sum('files_size')
  end
  
  def color
    return Digest::MD5.hexdigest(self.ip)[0,6]
  end
  
end
