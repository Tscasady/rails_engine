module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show 
        render json: ItemSerializer.new(Item.find(params[:id]))
      end

      def create
        merchant = Merchant.find(params[:item][:merchant_id])
        render json: ItemSerializer.new(merchant.items.create!(item_params)), status: :created
      end

      def update
        # TODO: refactor into validation on model, this is not very intention revealing
        merchant = Merchant.find(item_params[:merchant_id]) if item_params[:merchant_id]
        item = Item.find(params[:id])
        render json: ItemSerializer.new(Item.update(item.id, item_params))
      end

      def destroy
        render json: ItemSerializer.new(Item.destroy(params[:id]))
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
