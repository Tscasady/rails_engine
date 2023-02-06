require 'rails_helper'

RSpec.describe 'Merchante Items API' do
  before :each do
    @merchant = create(:merchant)
    @items = create_list(:item, 5, merchant_id: @merchant.id)
  end

  it 'can return items for a given merchant' do
    merchant = Merchant.first

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.length).to be 5
    items.each do |item|
      expect(item).to have_key(:id)
    end
  end
end

    
