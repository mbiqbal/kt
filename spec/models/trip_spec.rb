require 'rails_helper'

RSpec.describe Trip, type: :model do
  describe '#trip' do
    it 'has a valid factory' do
      expect(build(:trip)).to be_valid
    end

    it 'is invalid without a start_at' do
      expect(build(:trip, start_at: nil)).to_not be_valid
    end

    it 'is valid without a end at' do
      expect(build(:trip, end_at: nil)).to be_valid
    end

    it 'is invalid without a vehicle' do
      expect(build(:trip, vehicle: nil)).to_not be_valid
    end

    it 'is invalid without a user' do
      expect(build(:trip, user: nil)).to_not be_valid
    end

    it 'is invalid without a company' do
      expect(build(:trip, company: nil)).to_not be_valid
    end

  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:start_at).with_message(/can't be blank/) }
    it { should validate_presence_of(:vehicle).with_message(/can't be blank/) }
    it { should validate_presence_of(:user).with_message(/can't be blank/) }
    it { should validate_presence_of(:company).with_message(/can't be blank/) }

    describe 'Custom Validations' do
      it 'should validate start at is less than end at' do
        trip = build(:trip, start_at: Time.now, end_at: Time.now + 2.hours)
        expect(trip.valid?).to eq true

        trip = build(:trip, start_at: Time.now, end_at: Time.now - 2.hours)
        trip.save
        expect(trip.errors.messages[:start_at]).to eq ["can't be greater than or equal to end at"]
      end


      it 'should validate vehicle and user should belong to same company' do
        trip = build(:trip)
        expect(trip.company_id).to eq trip.user_company.id
        expect(trip.company_id).to eq trip.vehicle_company.id

        #Add a different user
        user = create(:user)
        trip = build(:trip, user: user)
        trip.save
        expect(trip.errors.messages[:vehicle].first).to eq "and user should belong to same company"

        #Add a different vehicle
        vehicle = create(:vehicle)
        trip = build(:trip, vehicle: vehicle)
        trip.save
        expect(trip.errors.messages[:vehicle].first).to eq "and user should belong to same company"

        #Add a different current user company
        trip = build(:trip, company: create(:company))
        trip.save
        expect(trip.errors.messages[:vehicle].first).to eq "and user should belong to same company"
      end

      it 'should validate no trips overlap for a user and vehicle at a given time' do
        trip = create(:trip)

        trip2 = build(:trip, user: trip.user, start_at: trip.start_at + 1.hours, end_at: trip.end_at + 1.hours)
        trip2.save
        expect(trip2.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip2.overlapping_trips.count).to eq 1

        #non overlapping scenario
        trip3 = build(:trip, user: trip.user, start_at: trip.start_at + 3.hours, end_at: trip.end_at + 4.hours)
        expect(trip3.save).to eq true

        # Vehicle overlap
        trip4 = build(:trip, vehicle: trip.vehicle, start_at: trip.start_at + 1.hours, end_at: trip.end_at + 1.hours)
        trip4.save
        expect(trip4.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip4.overlapping_trips.count).to eq 1

        # non overlapping scenario
        trip5 = build(:trip, vehicle: trip.vehicle, start_at: trip.start_at + 3.hours, end_at: trip.end_at + 4.hours)
        expect(trip5.save).to eq true
      end

      it 'should validate no trips overlap for a user and vehicle at a given time if end at not given' do
        trip = create(:trip)

        trip2 = build(:trip, user: trip.user, start_at: trip.start_at + 1.hours)
        trip2.save
        expect(trip2.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip2.overlapping_trips.count).to eq 1

        # Vehicle overlap
        trip2 = build(:trip, vehicle: trip.vehicle, start_at: trip.start_at + 1.hours)
        trip2.save
        expect(trip2.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip2.overlapping_trips.count).to eq 1
      end

      it 'should validate no trips overlap for a user and vehicle at a given time if existing trip continued' do
        trip = create(:trip, end_at: nil)

        trip2 = build(:trip, user: trip.user, start_at: trip.start_at + 1.hours, end_at: trip.start_at + 2.hours)
        trip2.save
        expect(trip2.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip2.overlapping_trips.count).to eq 1

        trip2 = build(:trip, user: trip.user, start_at: trip.start_at - 1.hours, end_at: trip.start_at + 1.hours)
        trip2.save
        expect(trip2.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip2.overlapping_trips.count).to eq 1

        # Vehicle overlap
        trip2 = build(:trip, vehicle: trip.vehicle, start_at: trip.start_at + 1.hours, end_at: trip.start_at + 2.hours)
        trip2.save
        expect(trip2.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip2.overlapping_trips.count).to eq 1

        trip2 = build(:trip, vehicle: trip.vehicle, start_at: trip.start_at - 1.hours, end_at: trip.start_at + 1.hours)
        trip2.save
        expect(trip2.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip2.overlapping_trips.count).to eq 1
      end

      it 'should validate no trips overlap for a user and vehicle at a given time if existing and new trips continues' do
        trip = create(:trip, end_at: nil)

        trip2 = build(:trip, user: trip.user, start_at: trip.start_at + 1.hours)
        trip2.save
        expect(trip2.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip2.overlapping_trips.count).to eq 1

        trip2 = build(:trip, user: trip.user, start_at: trip.start_at - 1.hours)
        trip2.save
        expect(trip2.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip2.overlapping_trips.count).to eq 1

        # Vehicle overlap
        trip2 = build(:trip, vehicle: trip.vehicle, start_at: trip.start_at + 1.hours)
        trip2.save
        expect(trip2.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip2.overlapping_trips.count).to eq 1

        trip2 = build(:trip, vehicle: trip.vehicle, start_at: trip.start_at - 1.hours)
        trip2.save
        expect(trip2.errors.messages[:overlapping].first).to eq "of users or vehicles for a time slot is not allowed."
        expect(trip2.overlapping_trips.count).to eq 1
      end


    end


  end


  describe 'ActiveRecord associations' do
    it { should belong_to(:user) }
    it { should belong_to(:vehicle) }
  end


end
