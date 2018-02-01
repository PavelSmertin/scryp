class AddRefsToPortfolios < ActiveRecord::Migration[5.1]
  def change
    add_reference :portfolios, :base_coin, references: :coin, index: true, null: false
    add_foreign_key :portfolios, :coins, column: :base_coin_id

    add_column :portfolios, :balance, :decimal
    add_column :portfolios, :original, :decimal
    add_column :portfolios, :price_now, :decimal
    add_column :portfolios, :price_original, :decimal
    add_column :portfolios, :price_24h, :decimal
    add_column :portfolios, :price_7d, :decimal
  end
end