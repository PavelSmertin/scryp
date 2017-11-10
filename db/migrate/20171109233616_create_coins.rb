class CreateCoins < ActiveRecord::Migration[5.1]
  def change
    create_table :coins do |t|
      t.string :name
      t.text :link
	  t.json :logo

      t.timestamps
    end
  end
end
