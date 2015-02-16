class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.string :content
      t.string :timelineable_type
      t.integer :timelineable_id

      t.timestamps null: false
    end
  end
end
