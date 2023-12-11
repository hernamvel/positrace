class CreateUrlLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :url_locations do |t|
      t.string :url
      t.integer :geolocation_id

      t.timestamps
    end
  end
end
