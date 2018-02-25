class AddFieldsToPortfolioCoins < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolio_coins, :change_24h, :decimal
    add_column :portfolio_coins, :change_pct_24h, :decimal
    add_column :portfolio_coins, :removed, :boolean
  end
end
