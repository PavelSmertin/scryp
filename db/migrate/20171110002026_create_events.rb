class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :describtion
      t.string :link
      t.timestamp :start_time
      t.timestamp :end_time
      t.references :coin, foreign_key: true

      t.timestamps
    end
  end
end
