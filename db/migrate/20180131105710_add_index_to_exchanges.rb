class AddIndexToExchanges < ActiveRecord::Migration[5.1]
  def change
    add_index :exchanges, :name, :unique => true
  end
end