class CreateVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicles do |t|
      t.string :registration_name, null: false
      t.belongs_to :company, foreign_key: true, null: false

      t.timestamps
    end
  end
end
