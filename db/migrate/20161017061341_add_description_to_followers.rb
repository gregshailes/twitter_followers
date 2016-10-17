class AddDescriptionToFollowers < ActiveRecord::Migration[5.0]
  def change
    add_column :followers, :description, :string
  end
end
