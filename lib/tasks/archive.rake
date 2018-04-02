namespace :kt do

  desc 'Archive old records.'
  task archive_old_trips: :environment do
    Trip.all.each do |trip|#where("created_at < ?", Time.now - 6.months).each do |trip|
      begin
        ActiveRecord::Base.transaction do
          # Will create a trip archive and destroy the trip record.
          # But if there is a problem, will log the trip that could not be archived
          TripArchive.create!(trip.attributes)
          trip.destroy!
        end
      rescue Exception => e
        Rails.logger.info(e.message)
        Rails.logger.info(trip)
      end
    end
  end
end

