class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.timestamp :stay_date
      t.timestamp :request_time
      t.string :request_approval
      t.integer :space_id
      t.integer :user_id
    end
    add_foreign_key :bookings, :users
    add_foreign_key :bookings, :spaces
  end
end
