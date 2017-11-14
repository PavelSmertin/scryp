class AddImageToNewests < ActiveRecord::Migration[5.1]
  def change
    add_column :newests, :image, :string
  end
end
