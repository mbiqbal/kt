class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.belongs_to :company, foreign_key: true, null: false
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
