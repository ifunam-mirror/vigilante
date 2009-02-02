class AddLatLngToCamera < ActiveRecord::Migration
  def self.up
    add_column :cameras, :lat, :string
    add_column :cameras, :lng, :string
  end

  def self.down
    remove_column :cameras, :lng
    remove_column :cameras, :lat
  end
end
