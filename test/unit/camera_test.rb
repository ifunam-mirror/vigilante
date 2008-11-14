require 'test_helper'
class CameraTest < ActiveSupport::TestCase
  fixtures :codecs, :qualities, :agents, :cameras
  
  should_require_attributes :ip, :location, :agent_id, :codec_id, :quality_id
  
  def test_should_not_allow_ip_with_bad_format
    @camera = Camera.build_valid(:ip => '000000')
    assert !@camera.valid?
  end 
end