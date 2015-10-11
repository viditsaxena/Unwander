class AddDetailsToItineraries < ActiveRecord::Migration
  def change
    add_column :itineraries, :details, :string
  end
end
