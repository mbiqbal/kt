namespace :kt do

  desc 'Archive old records.'
  task archive_old_trips: :environment do
    Trip.where("created_at < ?", Time.now - 6.months).each do |trip|
      begin
        TripArchive.create(trip.attributes)
        Rails.logger.info(trip)
      rescue Exception => e
        Rails.logger.info(e.message)
      end
    end
  end
end

