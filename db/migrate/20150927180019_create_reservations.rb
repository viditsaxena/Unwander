class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :name
      t.string :guest_phone
      t.integer :status, default: 0
      t.text :message
      t.string :phone_number
      t.belongs_to :itinerary, index:true

      t.timestamps null: false
    end
  end
end
