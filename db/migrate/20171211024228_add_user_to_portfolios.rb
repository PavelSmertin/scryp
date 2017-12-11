class AddUserToPortfolios < ActiveRecord::Migration[5.1]
  def change
    add_reference :portfolios, :user, foreign_key: true
  end
end
