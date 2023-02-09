require 'rails_helper'

RSpec.describe 'The Item Search Api' do
  before :each do
    @item1 = create(:item, name: "Ant", description: 'Non matching description', unit_price: 3)
    @item2 = create(:item, name: "Blant", description: 'Bless you ants', unit_price: 5555 )
    @item3 = create(:item, name: "lant", description: 'no one knows what this is', unit_price: 333)
    @item4 = create(:item, name: "Greg", description: 'Loves ants', unit_price: 111)
    @item4 = create(:item, name: "Bob", description: 'Bob is an item apparently', unit_price: 2)
  end

  describe 'single item search' do
    it 'can search for a single item by name' do
      get '/api/v1/items/find?name=ant'

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(item[:id]).to eq "#{@item1.id}"
      expect(item[:type]).to eq 'item'
      expect(item[:attributes][:name]).to eql "Ant"
    end

    it 'returns a item by preferencing alphabetical order by name over perfect match' do
      get '/api/v1/items/find?name=lant'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items[:id]).to eq "#{@item2.id}"
 
      expect(items[:type]).to eq 'item'

      expect(items[:attributes][:name]).to eql "Blant"
    end
    
    it 'can return an empty hash if no item is found' do
      get '/api/v1/items/find?name=NOMATCH'

      expect(response).to be_successful
      empty = JSON.parse(response.body, symbolize_names: true)

      expect(empty).to have_key(:data)
      expect(empty[:data]).to eq({})
    end

    it 'returns status 400 if no params are given' do
      get '/api/v1/items/find'

      expect(status).to eq 400
    end

    describe 'single item by price' do
      it 'can search by just min_price' do
        get '/api/v1/items/find?min_price=5'

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(item[:id]).to eq "#{@item2.id}"
      end

      it 'can search by just max_price' do
        get '/api/v1/items/find?max_price=333'

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(item[:id]).to eq "#{@item1.id}" 
      end

      it 'can search by min_price and max_price' do
        get '/api/v1/items/find?min_price=332&max_price=333'

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(item[:id]).to eq "#{@item3.id}"
      end

      it 'can return a status 400 if a price is less than 0' do
        get '/api/v1/items/find?min_price=-333'

        expect(status).to eq 400
      end
      
      it 'can return a status 400 if a min_price is greater than max_price' do
        get '/api/v1/items/find?min_price=333&max_price=2'

        expect(status).to eq 400
      end

      it 'can return status 400 if both name and price params are present' do
        get '/api/v1/items/find?name=test&min_price=333'

        expect(status).to eq 400

        get '/api/v1/items/find?name=test&max_price=333'

        expect(status).to eq 400

        get '/api/v1/items/find?name=test&min_price=2&max_price=333'

        expect(status).to eq 400
      end
    end
  end

  describe 'search_all' do
    it 'returns the names of all items that match a given search' do
      get '/api/v1/items/find_all?name=ant'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      items.each do |item|
        expect(item.length).to eq 3
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an String

        expect(item).to have_key(:type)
        expect(item[:type]).to be_a(String)
        expect(item[:type]).to eq 'item'

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a Hash

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name].downcase).to include 'ant'
      end
    end

    it 'returns status 400 if no params are given' do
      get '/api/v1/items/find_all'

      expect(status).to eq 400
    end
  end
end 
