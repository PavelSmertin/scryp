class AddSymbolToPortfolioCoins < ActiveRecord::Migration[5.1]
  def change
  	add_column :portfolio_coins, :symbol, :string, null: false
  	add_column :portfolio_coins, :exchange, :string, null: false
  end
end
