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
        render json: ItemSerializer.new(merchant.items.create(item_params))
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price)
      end
    end
  end
end
