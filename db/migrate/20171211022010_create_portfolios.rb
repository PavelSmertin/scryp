class CreatePortfolios < ActiveRecord::Migration[5.1]
  def change
    create_table :portfolios do |t|
      t.string :user_name
      t.integer :coins_count
      t.decimal :profit_24h
      t.decimal :profit_7d

      t.timestamps
    end
  end
end
