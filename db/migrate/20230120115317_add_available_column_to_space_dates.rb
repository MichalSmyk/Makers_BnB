class AddAvailableColumnToSpaceDates < ActiveRecord::Migration[7.0]
  def change
    add_column(:space_dates, :available?, :string)
  end
end
