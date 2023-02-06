require 'rails_helper'

RSpec.describe 'Merchant API' do
  before :each do
    create_list(:merchant, 5)
  end
  it 'can return all merchants' do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an Integer

      expect(merchant).to have_key(:type)
      expect(merchant[:title]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:author]).to be_a(Hash)

      expect(merchant[:attributes][:name]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can return a single merchant' do
    merchant = Merchant.first

    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an Integer

    expect(merchant).to have_key(:type)
    expect(merchant[:title]).to be_a(String)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:author]).to be_a(Hash)

    expect(merchant[:attributes][:name]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end
end
