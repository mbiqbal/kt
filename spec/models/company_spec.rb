require 'rails_helper'

RSpec.describe Company, type: :model do

  describe '#company' do
    it 'has a valid factory' do
      expect(build(:company)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:company, name: nil)).to_not be_valid
      expect(build(:company, name: '')).to_not be_valid
    end

  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:name).with_message(/can't be blank/) }
  end

  describe 'ActiveRecord associations' do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_many(:vehicles).dependent(:destroy) }
    it { should have_many(:user_trips).through(:users).source(:trips) }
    it { should have_many(:vehicle_trips).through(:vehicles).source(:trips) }
    it { should have_many(:trips) }
  end
end
