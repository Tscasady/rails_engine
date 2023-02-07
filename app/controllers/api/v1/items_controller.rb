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
        item = Item.find(params[:id])
        if item.update(item_params)
          render json: ItemSerializer.new(item)
        else
          raise ActiveRecord::RecordInvalid.new(item)
        end
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
