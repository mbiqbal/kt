require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe '#vehicle' do
    it 'has a valid factory' do
      expect(build(:vehicle)).to be_valid
    end

    it 'is invalid without a registration name' do
      expect(build(:vehicle, registration_name: nil)).to_not be_valid
      expect(build(:vehicle, registration_name: '')).to_not be_valid
    end

  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:registration_name).with_message(/can't be blank/) }
  end


  describe 'ActiveRecord associations' do
    it { should belong_to(:company) }
    it { should have_many(:trips).dependent(:destroy) }
  end
end
