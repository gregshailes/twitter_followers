class AddLocationToFollowers < ActiveRecord::Migration[5.0]
  def change
    add_column :followers, :location, :string
  end
end
