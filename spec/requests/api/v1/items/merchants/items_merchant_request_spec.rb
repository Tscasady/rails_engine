require 'rails_helper'

RSpec.describe 'The Item Merchant API' do
  before :each do
    @merchant = create(:merchant)
    @item = create(:item, merchant_id: @merchant.id)
  end

  it 'can return the merchant data associated with a given item' do

    get "/api/v1/items/#{@item.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an String

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to be_a String

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a String
  end

  it 'returns status 404 if merchant is not found' do
    item = build(:item, merchant_id: 123123123)
    get "/api/v1/items/#{item.id}/merchant"

    expect(response.status).to eq 404
  end

  it 'returns status 404 if a bad param is given' do
    get "/api/v1/items/string/merchant"

    expect(response.status).to eq 404 
  end
end
