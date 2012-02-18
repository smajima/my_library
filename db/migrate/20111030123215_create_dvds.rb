class CreateDvds < ActiveRecord::Migration
  def change
    create_table :dvds do |t|
      t.integer :ganre
      t.string :title
      t.string :cast

      t.timestamps
    end
  end
end
