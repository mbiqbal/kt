class Company < ApplicationRecord
  validates_presence_of :name

  has_many :users, dependent: :destroy
  has_many :vehicles, dependent: :destroy
  has_many :user_trips, through: :users, source: :trips
  has_many :vehicle_trips, through: :vehicles, source: :trips
  has_many :trips
end
