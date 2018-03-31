class User < ApplicationRecord
  validates_presence_of :name, :company, :role
  validates :role, inclusion: { in: ['admin', 'read_only'] }

  belongs_to :company
  has_many :trips, dependent: :destroy

  enum role: [:read_only, :admin]

end
