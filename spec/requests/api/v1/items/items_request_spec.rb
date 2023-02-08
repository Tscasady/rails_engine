require 'rails_helper'

RSpec.describe 'Item API' do
  before :each do
    @merchant = create(:merchant)
    @item1 = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)
    @item3 = create(:item, merchant: @merchant)
    @invoice1 = create(:invoice, merchant: @merchant) 
    @invoice2 = create(:invoice, merchant: @merchant) 
    @invoice_item1 = create(:invoice_item, item: @item1, invoice: @invoice1)
    @invoice_item2 = create(:invoice_item, item: @item1, invoice: @invoice2)
    @invoice_item3 = create(:invoice_item, item: @item2, invoice: @invoice2)
    @invoice_item4 = create(:invoice_item, item: @item3, invoice: @invoice2)
  end

  it 'can return all items' do
    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(3)
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

  it 'returns status 404 if item is not found' do
    get "/api/v1/items/999999999"

    expect(status).to eq 404

    get "/api/v1/items/bad_query"

    expect(status).to eq 404
  end

  describe 'create' do
    it 'can create an item' do
      item_params = { name: 'Test Item',
                      description: 'This is what the item is like',
                      unit_price: 15.5,
                      merchant_id: @merchant.id }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(Item.all.count).to be 4

      expect(item).to have_key(:type)
      expect(item[:type]).to eq 'item'

      expect(item[:attributes][:name]).to eq 'Test Item'

      expect(item[:attributes][:description]).to eq 'This is what the item is like'

      expect(item[:attributes][:unit_price]).to eq 15.5
    end

    it 'can return an error if an attribute is not provided' do
      item_params = { name: 'Test Item',
                      unit_price: 15.5,
                      merchant_id: @merchant.id }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(status).to eq 422
    end
  end

  describe 'edit item' do
    it 'can edit an item' do
      item = Item.first
      previous_name = item.name
      item_params = { name: 'A New Item Name' }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

      item.reload

      expect(response).to be_successful

      expect(item.name).to_not eq previous_name
      expect(item.name).to eq "A New Item Name"
    end

    it 'can edit a different field' do
      item = Item.first
      previous_name = item.name
      item_params = { description: 'A New Item Description' }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

      item.reload

      expect(response).to be_successful

      expect(item.description).to_not eq previous_name
      expect(item.description).to eq "A New Item Description"
    end

    it 'will raise a 404 if item is not found' do
      item_params = { name: 'A New Item Name' }
      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch "/api/v1/items/999999", headers: headers, params: JSON.generate(item: item_params)
      expect(status).to be 404
    end

    it 'will raise a 404 if merchant is not found' do
      item = Item.first
      item_params = { name: 'A New Item Name', merchant_id: 99999999 }
      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)
      expect(status).to be 422
    end
  end

  it 'can delete an item' do
    id = @item1.id
    expect { delete "/api/v1/items/#{@item1.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect { Item.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    expect { Invoice.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    expect(@invoice2.items.count).to eq 2
  end
end
