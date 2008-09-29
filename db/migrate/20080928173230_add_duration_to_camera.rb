class AddDurationToCamera < ActiveRecord::Migration
  def self.up
    add_column :cameras, :video_duration, :integer
  end

  def self.down
    remove_column :cameras, :video_duration
  end
end
