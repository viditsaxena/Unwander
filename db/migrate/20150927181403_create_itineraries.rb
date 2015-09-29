class CreateItineraries < ActiveRecord::Migration
  def change
    create_table :itineraries do |t|
      t.belongs_to :user, index:true
      t.string :description
      t.string :image_url

      t.timestamps null: false
    end
  end
end
