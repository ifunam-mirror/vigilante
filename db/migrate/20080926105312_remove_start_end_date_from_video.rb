class RemoveStartEndDateFromVideo < ActiveRecord::Migration
  def self.up
    remove_column :videos, :date
    remove_column :videos, :start
    remove_column :videos, :end
    add_column  :videos, :start, :datetime
    add_column  :videos, :end, :datetime
  end

  def self.down
    add_column :videos, :end, :string
    add_column :videos, :start, :string
    add_column :videos, :date, :date
    remove_column :videos, :start
    remove_column :videos, :end
  end
end
