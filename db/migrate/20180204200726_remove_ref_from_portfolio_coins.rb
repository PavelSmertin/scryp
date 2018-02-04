class RemoveRefFromPortfolioCoins < ActiveRecord::Migration[5.1]
  def change
  	remove_reference :portfolio_coins, :portfolio, foreign_key: true, null: false
  	add_column :portfolio_coins, :portfolio_id, :bigint
  end
end
