require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relations' do
    it { should have_many :items }
  end
end
