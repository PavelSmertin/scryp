class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :portfolio, foreign_key: true, null: false
      t.references :portfolio_coin, foreign_key: true, null: false

      t.references :portfolio_pair, references: :portfolio_coins, index: true, null: false
      t.foreign_key :portfolio_coins, column: :portfolio_pair_id

      t.references :exchange, foreign_key: true, null: false

      t.decimal :portfolio_balance
      t.decimal :amount
      t.decimal :price
      t.text :description
      t.timestamp :datetime

      t.timestamps
    end
  end
end
