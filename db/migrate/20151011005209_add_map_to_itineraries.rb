class AddMapToItineraries < ActiveRecord::Migration
  def change
    add_column :itineraries, :map, :string
  end
end
