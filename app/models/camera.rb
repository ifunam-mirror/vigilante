require 'cronedit'

class Camera < ActiveRecord::Base
  has_many :videos
  belongs_to :quality
  
  # Callbacks
  after_save :edit_crontab
  
  def edit_crontab
    ct = CronEdit::Crontab.new 'root'
    ct.add this.ip, {:minute => "*/#{this.duration}",
                     :command => "" }
    ct.commit
  end
end
