class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.belongs_to :vehicle, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :company, foreign_key: true, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, default: nil
      t.integer :distance, default: 0

      t.timestamps
    end
  end
end
