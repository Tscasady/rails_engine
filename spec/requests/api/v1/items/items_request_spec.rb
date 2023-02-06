require 'rails_helper'

RSpec.describe 'Item API' do

  before :each do
    create_list(:item, 5)
  end

  it 'can return all items' do
    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(5)
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
#TODO merchant_id can be removied?
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a Integer
    end
  end

  it 'can return a single item' do
    item = Item.first

    get "/api/v1/items/#{item.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

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
  end
end
