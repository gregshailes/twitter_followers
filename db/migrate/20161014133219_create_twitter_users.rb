class CreateTwitterUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :twitter_users do |t|
      t.string :UserName

      t.timestamps
    end
  end
end
