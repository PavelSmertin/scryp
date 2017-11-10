class AddEventToNewests < ActiveRecord::Migration[5.1]
  def change
    add_reference :newests, :event, foreign_key: true
  end
end
