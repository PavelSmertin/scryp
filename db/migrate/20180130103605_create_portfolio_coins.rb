class CreatePortfolioCoins < ActiveRecord::Migration[5.1]
  def change
    create_table :portfolio_coins do |t|
      t.references :coin, foreign_key: true, null: false
      t.references :portfolio, foreign_key: true, null: false
      t.references :exchange, foreign_key: true, null: false

      t.decimal :original
      t.decimal :price_now
      t.decimal :price_original
      t.decimal :price_24h
      t.decimal :price_7d

      t.timestamps
    end
  end
end
