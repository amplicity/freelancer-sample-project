class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.datetime :from
      t.datetime :to
      t.boolean :is_deleted, :default => false
      t.timestamps null: false
    end
  end
end
