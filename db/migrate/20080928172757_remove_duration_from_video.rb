class RemoveDurationFromVideo < ActiveRecord::Migration
  def self.up
    remove_column :videos, :duration
  end

  def self.down
    add_column :videos, :duration, :integer
  end
end
