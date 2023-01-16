class CreateSpaces < ActiveRecord::Migration[7.0]
  def change
    create_table :spaces do |t|
      t.string :name
      t.string :description
      t.money :price
    end
    add_foreign_key :spaces, :users
  end
end
