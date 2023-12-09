class CreateGeolocations < ActiveRecord::Migration[7.1]
  def change
    create_table :geolocations do |t|
      t.string :ip
      t.string :hostname
      t.string :country_code
      t.string :country_name
      t.string :region_code
      t.string :city
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :geolocations, :ip, unique: true
    add_index :geolocations, :hostname, unique: true
  end
end
