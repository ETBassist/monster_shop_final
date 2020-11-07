require 'rails_helper'

describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :percent }
    it { should validate_presence_of :required_quantity }
  end
end
