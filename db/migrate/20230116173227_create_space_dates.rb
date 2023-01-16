class CreateSpaceDates < ActiveRecord::Migration[7.0]
  def change
    create_table :space_dates do |t|
      t.timestamp :date_available
      t.integer :space_id
    end
    add_foreign_key :space_dates, :spaces
  end
end
