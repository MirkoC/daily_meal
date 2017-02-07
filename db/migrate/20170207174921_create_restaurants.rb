class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :website
      t.decimal :latitude
      t.decimal :longitude
      t.string :logo

      t.timestamps
    end
  end
end
