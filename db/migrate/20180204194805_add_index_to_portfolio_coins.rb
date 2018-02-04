class AddIndexToPortfolioCoins < ActiveRecord::Migration[5.1]
  def change
  	remove_index :portfolio_coins, ["user_id", "portfolio_id"]
  	add_column :portfolio_coins, :portfolio_coin_id, :bigint
    add_index :portfolio_coins, ["user_id", "portfolio_coin_id"], :unique => true
  end
end
