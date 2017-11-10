class CreateNewests < ActiveRecord::Migration[5.1]
  def change
    create_table :newests do |t|
      t.string :link
      t.text :text

      t.timestamps
    end
  end
end
