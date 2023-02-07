require 'rails_helper'

RSpec.describe 'Merchant API' do

  before :each do
    create_list(:merchant, 5)
  end

  it 'can return all merchants' do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an String

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can return a single merchant' do
    original_merchant = Merchant.first

    get "/api/v1/merchants/#{original_merchant.id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an String
    expect(merchant[:id]).to eq original_merchant.id.to_s

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to be_a(String)
    expect(merchant[:type]).to eq 'merchant'

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
    expect(merchant[:attributes][:name]).to eq original_merchant.name
  end
end
