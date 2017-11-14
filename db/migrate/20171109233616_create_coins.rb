class CreateCoins < ActiveRecord::Migration[5.1]
  def change
    create_table :coins do |t|
	  t.json :logo
	  t.string :symbol
	  t.string :coin_name
	  t.string :full_name
	  t.string :algorithm
	  t.string :proof_type
	  t.decimal :fully_premined, precision: 22, scale: 0
	  t.decimal :total_coin_supply, precision: 22, scale: 0
	  t.decimal :pre_mined_value, precision: 22, scale: 0
	  t.decimal :total_coins_free_float, precision: 22, scale: 0
	  t.integer :sort_order
	  t.boolean :sponsored
      t.timestamps
    end
  end
end
