class AddFieldsToPortfolio < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :removed, :boolean
  end
end
