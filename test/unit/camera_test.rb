require File.join(File.dirname(__FILE__), '../test_helper')
class CameraTest < ActiveSupport::TestCase
  fixtures :codecs, :qualities, :agents, :cameras, :videos
  
  should_require_attributes :ip, :location, :agent_id, :codec_id, :quality_id
  should_not_allow_nil_value_for :agent_id, :codec_id, :quality_id
  should_belong_to :agent
  should_belong_to :codec
  should_belong_to :quality
  
  should_have_many :videos
  
  def test_should_not_allow_ip_with_bad_format
    @camera = Camera.build_valid(:ip => '000000')
    assert !@camera.valid?
    @camera.ip = '10.10.1.100'
    assert @camera.valid?
  end 
  
  def test_should_add_task_to_crontab_after_save
    
    initial_size = CronEdit::Crontab.List.size
    assert_difference "Camera.count" do 
      @camera = Camera.new(Camera.valid_hash(:ip => '10.10.10.2'))
      @camera.save
    end
    assert_equal initial_size + 1, CronEdit::Crontab.List.size
    @camera.destroy
  end
  
  def test_should_remove_task_to_crontab_after_destroy
    initial_size = CronEdit::Crontab.List.size
    assert_difference "Camera.count", -1 do
      Camera.first.destroy
    end
    assert_equal initial_size - 1, CronEdit::Crontab.List.size
  end
  
  def test_should_know_its_disk_usage
    Camera.all.each do |camera|
      if camera.videos.size == 0
        assert_equal(0, camera.disk_usage)
      else
        assert(camera.disk_usage > 0, "Disk usage is not being calculated")
      end
    end
  end
end