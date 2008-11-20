require File.join(File.dirname(__FILE__), '../test_helper')
require 'filetesthelper'
include FileTestHelper

class VideoTest < ActiveSupport::TestCase
  
  should_require_attributes :filename, :path, :camera_id
  should_not_allow_nil_value_for :camera_id
  should_belong_to :camera
  
  def test_should_calculate_md5_and_files_size_before_save
    @video = Video.new(:filename => "2040", 
                       :path => "test/2040.avi",
                       :thumbnail => "test/2040-1.jpg",
                       :camera_id => 1)
    assert_nil @video.md5
    assert_nil @video.files_size
    with_files("test/2040.avi" => "video's contents",
              "test/2040-1.jpg" => "thumbnail's contents") do
      @video.save
      assert_not_nil @video.md5
      assert_not_nil @video.files_size
      assert @video.files_size > 0, "File's size is invalid"
    end
  end
  
  
end