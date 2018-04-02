class TripsController < ApplicationController
  before_action :check_params, only: :index
  before_action :check_permissions, only: [:create, :trips_summary]
  before_action :ensure_one_of_user_id_or_vehicle_id_is_present, only: :trips_summary


  # Params
  # user_id : Id of the user
  # vehicle_id: Id of vehicle
  # start_at: UTC format time
  # end_at UTC: format time
  def index
    @trips = @company.trips.search(params)
    render json: @trips, status: 201
  end

  # Params
  #   {
  #       "trips_data": [
  #           {
  #               "vehicle_id": 5,
  #               "user_id": 4,
  #               "start_at": "2018-04-01 00:00:1",
  #               "end_at": "2018-04-01 00:59:1",
  #               "distance": 3
  #           },
  #           {
  #               "vehicle_id": 5,
  #               "user_id": 4,
  #               "start_at": "2018-04-01 01:00:1",
  #               "end_at": "2018-04-01 01:59:1",
  #               "distance": 2
  #           }
  #
  #
  #       ]
  #   }
  def create
    trips_created = Trip.bulk_create(params, @company.id)
    raise Exception unless trips_created
    render json: {success: true}, status: 201
  end

  # Params
  # user_id : Id of the user
  # vehicle_id: Id of vehicle
  # Expects one of user_id or vehicle_id. user_id will be given priority if both passed
  # start_at: UTC format time
  # end_at UTC: format time
  def trips_summary
    trip_distance = @company.trips.search(params).sum(:distance)
    render json: {total_distance: trip_distance}, status: 201
  end

  private

  def trips_params
    params.permit(trips_data: [])
  end

  def check_params
    raise Exceptions::InvalidParams if params[:start_at].blank? or params[:end_at].blank?
  end

  def check_permissions
    raise Exceptions::AuthorizationError unless current_user.admin?
  end

  def ensure_one_of_user_id_or_vehicle_id_is_present
    params[:vehicle_id] = nil if params[:user_id].present?
  end

end
