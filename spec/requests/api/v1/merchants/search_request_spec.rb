require 'rails_helper'

RSpec.describe 'The Merchant Search Api' do
  describe 'single merchant search' do
    before :each do
      @merchant1 = create(:merchant, name: "Ant")
      @merchant2 = create(:merchant, name: "Blant")
      @merchant3 = create(:merchant, name: "lant")
      @merchant4 = create(:merchant, name: "Greg")
    end

    it 'can search for a single merchant by name' do
      get "/api/v1/merchants/find?name=ant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an String

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)
      expect(merchant[:type]).to eq 'merchant'

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a Hash

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to eql "Ant"
    end

    it 'returns names by preferencing alphabetical order over perfect match' do
      get "/api/v1/merchants/find?name=lant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an String

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)
      expect(merchant[:type]).to eq 'merchant'

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a Hash

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to eql "Blant"
    end
  end
end 
