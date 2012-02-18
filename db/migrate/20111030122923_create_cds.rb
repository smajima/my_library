class CreateCds < ActiveRecord::Migration
  def change
    create_table :cds do |t|
      t.integer :ganre
      t.string :artist
      t.string :artist_for_sort
      t.string :capital
      t.string :title
      t.integer :issued_year

      t.timestamps
    end
  end
end
