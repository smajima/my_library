class PlaceAddToCd < ActiveRecord::Migration
  def up
    add_column :cds, :place, :string
  end

  def down
    drop_column :cds, :place
  end
end
