class AddPicToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pic, :string
  end
end
