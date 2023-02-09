require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relations' do
    it { should have_many :items }
  end

  describe 'search' do
    let!(:merchant1) { create(:merchant, name: "Bob") }
    let!(:merchant2) { create(:merchant, name: "Boss") }
    let!(:merchant3) { create(:merchant, name: "robert") }

    it 'can return a list of merchants whose name partially matches the given case insensitive query' do
      search_params = 'bo'
      expect(Merchant.search(search_params)).to eq [merchant1, merchant2]

      search_params = 'ber'
      expect(Merchant.search(search_params)).to eq [merchant3]
    end
  end
end
