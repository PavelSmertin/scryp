class AddKeyToPortfolioCoins < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolio_coins, :user_id, :bigint
    add_index :portfolio_coins, ["user_id", "portfolio_id"], :unique => true
  end
end
