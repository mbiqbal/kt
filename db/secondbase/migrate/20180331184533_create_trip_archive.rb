class CreateTripArchive < ActiveRecord::Migration[5.1]
  def change
    create_table :trip_archives do |t|
      t.integer :vehicle_id, null: false
      t.integer :user_id,  null: false
      t.integer :company_id, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, default: nil
      t.integer :distance, default: 0

      t.timestamps
    end
  end
end
