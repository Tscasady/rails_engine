require 'rails_helper'

RSpec.describe 'Item API' do
  before :each do
    @merchant = create(:merchant)
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

  it 'can create an item' do
    item_params = { name: 'Test Item',
                    description: 'This is what the item is like',
                    unit_price: 15.5,
                    merchant_id: @merchant.id }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(Item.all.count).to be 6

    expect(item).to have_key(:type)
    expect(item[:type]).to eq 'item'

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to eq 'Test Item'

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to eq 'This is what the item is like'

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to eq 15.5
  end

  it 'can edit an item' do
    # TODO: test multiple fields
    item = Item.first
    previous_name = item.name
    item_params = { name: 'A New Item Name' }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

    item.reload

    expect(response).to be_successful

    expect(item.name).to_not eq previous_name
  end

  it 'can delete an item' do
    # TODO: Do I test the destruction of dependents here?
    item = Item.last

    expect { delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

end
