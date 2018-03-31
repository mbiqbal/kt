require 'rails_helper'

RSpec.describe TripsController, type: :controller do
  describe "#index" do
    let(:company) {create(:company)}
    let(:user) {create(:user, company: company)}
    let(:vehicle) {create(:vehicle, company: company)}
    let(:trip) {create(:trip, user: user, vehicle: vehicle, company: company, start_at: Time.now.utc, end_at: Time.now.utc + 2.hours)}

    it "get listing of trips" do
      auth_request(user.id)
      get :index, format: :json, params: {start_at: Time.now.utc, end_at: Time.now.utc + 2.hours}
      expect(response.status).to eq 201
    end

    it "not get listing of trips if start and end time not given" do
      auth_request(user.id)
      get :index, format: :json
      expect(response.status).to eq 400
    end
  end


  describe "#create" do
    let(:company) {create(:company)}
    let(:readonly_user) {create(:user, company: company)}
    let(:admin_user) {create(:user, company: company, role: 'admin')}
    let(:vehicle) {create(:vehicle, company: company)}

    it "should not create if user is not admin" do
      auth_request(readonly_user.id)
      post :create, format: :json
      expect(response.status).to eq 401
    end

    it "should not create if user is not admin" do
      auth_request(admin_user.id)
      get :create, format: :json, params: {
          "trips_data": [
              {
                  "vehicle_id": vehicle.id,
                  "user_id": readonly_user.id,
                  "start_at": "2018-04-01 00:00:1",
                  "end_at": "2018-04-01 00:59:1",
                  "distance": 3
              },
              {
                  "vehicle_id": vehicle.id,
                  "user_id": readonly_user.id,
                  "start_at": "2018-04-01 01:00:1",
                  "end_at": "2018-04-01 01:59:1",
                  "distance": 2
              }


          ]
      }
      expect(company.trips.count).to eq 2
      expect(response.status).to eq 201
    end
  end
end
