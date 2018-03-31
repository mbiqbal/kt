require 'rails_helper'

RSpec.describe User, type: :model do
  let(:roles_order) { %w{read_only admin} }

  describe '#user' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:user, name: nil)).to_not be_valid
      expect(build(:user, name: '')).to_not be_valid
    end

    it 'is invalid without a role' do
      expect(build(:user, role: nil)).to_not be_valid
    end

    it 'is invalid without a company' do
      expect(build(:user, company: nil)).to_not be_valid
    end

  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:name).with_message(/can't be blank/) }
    it { should validate_presence_of(:role).with_message(/can't be blank/) }
    it { should validate_presence_of(:company).with_message(/can't be blank/) }
    it { is_expected.to define_enum_for(:role).with(%w(read_only admin)) }
  end

  describe '#role' do
    it 'has the right index' do
      roles_order.each_with_index do |item, index|
        expect(described_class.roles[item]).to eq index
      end
    end
  end

  describe 'ActiveRecord associations' do
    it { should belong_to(:company) }
    it { should have_many(:trips).dependent(:destroy) }
  end

end
