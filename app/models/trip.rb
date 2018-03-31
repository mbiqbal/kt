class Trip < ApplicationRecord
  validates_presence_of :user, :vehicle, :start_at, :company
  validate :start_at_less_than_end_at
  validate :vehicle_and_user_should_belong_to_creators_company
  validate :trip_does_not_overlap_with_another_trip

  belongs_to :user
  belongs_to :vehicle
  belongs_to :company

  scope :for_user, ->(user_id) { where("user_id = ?", user_id) }
  scope :for_vehicle, ->(vehicle_id) { where("vehicle_id = ?", vehicle_id) }
  scope :in_time, ->(start_at, end_at) { where("start_at >= ? AND end_at <= ?", start_at, end_at) }

  delegate :company, to: :user, prefix: :user
  delegate :company, to: :vehicle, prefix: :vehicle

  def start_at_less_than_end_at
    if start_at.present? && end_at.present? && start_at >= end_at
      errors.add(:start_at, "can't be greater than or equal to end at")
    end
  end

  def vehicle_and_user_should_belong_to_creators_company
    if user.present? && vehicle.present? && start_at.present? && company.present?
      errors.add(:vehicle, "and user should belong to same company") if self.vehicle_company.id != self.company_id or
                                                                        self.user_company.id != self.company_id
    end
  end

  def trip_does_not_overlap_with_another_trip
    if vehicle.present? && user.present? && start_at.present? && company.present?
      overlappingtrips = overlapping_trips
      errors.add(:overlapping, 'of users or vehicles for a time slot is not allowed.') unless overlappingtrips.count.zero?
    end
  end

  def overlapping_trips
    # TODO add check for self since for old records it will fetch the current record as well as it overlaps with itself
    # Its fine for old records
    trips = Trip.where("vehicle_id = ? OR user_id = ?", vehicle_id, user_id)
    if end_at.present?
      trips = trips.where('start_at <= ? AND (end_at >= ? OR end_at IS NULL)', self.end_at, self.start_at)
    else
      trips = trips.where('(start_at <= ? AND (end_at >= ? OR end_at IS NULL)) OR (start_at >= ?) ' , self.start_at, self.start_at, self.start_at)
    end
    trips
  end


  def self.search(options)
    trips = in_time(options[:start_at], options[:end_at])
    if options[:user_id]
      trips = trips.for_user(options[:user_id].to_i)
    end
    if options[:vehicle_id]
      trips = trips.for_vehicle(options[:vehicle_id].to_i)
    end
    trips
  end

  def self.bulk_create(trips, company_id)
    Trip.transaction do
      begin
        trips["trips_data"].each do |trip_data|
          t = Trip.create!(trip_data.permit(:vehicle_id, :user_id, :start_at, :end_at, :distance)
                               .merge(company_id: company_id))
        end
      rescue Exception => e
        raise ActiveRecord::Rollback and return false
      end
    end
  end
end
