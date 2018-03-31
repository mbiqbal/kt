class Vehicle < ApplicationRecord
  validates_presence_of :registration_name, :company

  belongs_to :company
  has_many :trips, dependent: :destroy
end
