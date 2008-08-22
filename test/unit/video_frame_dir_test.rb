require File.expand_path(File.dirname(__FILE__) + "/../../lib/video_frame_dir")
require 'test_helper'

class VideoFrameDirTest < Test::Unit::TestCase
  
  def setup
    @video_frame_dir = VideoFrameDir.new(RAILS_ROOT)
  end
  
  def test_should_list_existing_directories
    @video_frame_dir.directories(["app", "lib", "config", "unexistent_dir"])
    assert_equal 3, @video_frame_dir.dirs.size
  end

  def test_should_search_file_using_rb_extension
    @video_frame_dir.directories ["config/environments"]
    puts @video_frame_dir.dirs
    assert_equal 3, @video_frame_dir.search_files("rb").size
  end
  
  def test_should_generate_directory_names_based_on_time_range
    first = Time.parse("2008-08-21 18:15")
    last = first + 10.minutes
    assert_equal 11, @video_frame_dir.time_range(first, last).size
  end
  
  # def test_should_list_files_from_specific_date_and_time
  #  TODO: Implement this test
  # end
  
  
end