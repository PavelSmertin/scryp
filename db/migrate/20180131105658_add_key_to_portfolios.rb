class AddKeyToPortfolios < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :portfolio_id, :bigint
    add_index :portfolios, ["user_id", "portfolio_id"], :unique => true
  end
end
