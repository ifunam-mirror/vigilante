class AddMd5AndFilesSizeToVideo < ActiveRecord::Migration
  def self.up
    add_column :videos, :md5, :string
    add_column :videos, :files_size, :integer
  end

  def self.down
    remove_column :videos, :files_size
    remove_column :videos, :md5
  end
end
