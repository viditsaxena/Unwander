class AddLocationToItineraries < ActiveRecord::Migration
  def change
    add_column :itineraries, :location, :string
  end
end
