require 'rails_helper'

RSpec.describe 'The Merchant Search Api' do
  before :each do
    @merchant1 = create(:merchant, name: "Ant")
    @merchant2 = create(:merchant, name: "Blant")
    @merchant3 = create(:merchant, name: "lant")
    @merchant4 = create(:merchant, name: "Greg")
  end

  describe 'single merchant search' do
    it 'can search for a single merchant by name' do
      get '/api/v1/merchants/find?name=ant'

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant[:id]).to eq "#{@merchant1.id}"
      expect(merchant[:type]).to eq 'merchant'
      expect(merchant[:attributes][:name]).to eq "Ant"
    end

    it 'will return an empty hash if no objects match the search' do
      get '/api/v1/merchants/find?name=NOMATCH'

      expect(response).to be_successful

      empty = JSON.parse(response.body, symbolize_names: true)

      expect(empty).to have_key(:data)
      expect(empty[:data]).to eq({})
    end

    it 'returns a merchant by preferencing alphabetical order by name over perfect match' do
      get '/api/v1/merchants/find?name=lant'

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

    it 'returns status 400 if no params are given' do
      get '/api/v1/merchants/find'

      expect(status).to eq 400
    end
  end

  describe 'search_all' do
    it 'returns the names of all merchants that match a given search' do
      get '/api/v1/merchants/find_all?name=ant'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      merchants.each do |merchant|
        expect(merchant.length).to eq 3
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an String

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)
        expect(merchant[:type]).to eq 'merchant'

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a Hash

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name].downcase).to include 'ant'
      end
    end

    it 'returns status 400 if no params are given' do
      get '/api/v1/merchants/find_all'

      expect(status).to eq 400
    end
  end
end 
