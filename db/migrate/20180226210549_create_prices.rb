class CreatePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :prices do |t|
      t.string :exchange, index: true
      t.string :symbol, index: true
      t.timestamp :date, index: true
      t.decimal :usdt
      t.decimal :usd
      t.decimal :eur
      t.decimal :btc
      t.timestamps
    end
    add_index :prices, ["exchange", "symbol", "date"], :unique => true
  end
end
