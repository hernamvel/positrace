class RemoveHostnameFromGeolocations < ActiveRecord::Migration[7.1]
  def change
    remove_column :geolocations, :hostname
  end
end
