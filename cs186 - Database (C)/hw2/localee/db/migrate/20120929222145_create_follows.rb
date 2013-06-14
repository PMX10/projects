class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.references :location
      t.references :user

      t.timestamps
    end
    add_index :follows, :location_id
    add_index :follows, :user_id
  end
end
