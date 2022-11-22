class AddScreenNameToFollowers < ActiveRecord::Migration[5.0]
  def change
    add_column :followers, :screen_name, :string
  end
end
