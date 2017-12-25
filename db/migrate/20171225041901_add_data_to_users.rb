class AddDataToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :data, :text
  end
end
