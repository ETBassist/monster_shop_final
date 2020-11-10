require 'rails_helper'

describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of :percent }
    it { should validate_presence_of :required_quantity }
    it { should validate_numericality_of :percent }
    it { should validate_numericality_of :required_quantity }
  end
end
