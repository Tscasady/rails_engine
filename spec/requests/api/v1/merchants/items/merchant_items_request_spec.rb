require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  before :each do
    @merchant = create(:merchant)
    @items = create_list(:item, 5, merchant_id: @merchant.id)
  end

  describe 'happy path' do
    it 'can return items for a given merchant' do
      merchant = Merchant.first

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.length).to be 5
      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an String

        expect(item).to have_key(:type)
        expect(item[:type]).to be_a String

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a String

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a String

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a Float

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to eq @merchant.id
      end
    end
  end

  describe 'sad path' do
    it 'returns 404 if merchant id does not exist' do
      get '/api/v1/merchants/123123123/items'

      expect(status).to eq 404
    end
  end

end

    
