module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController
        def index
          items = Item.where(merchant_id: params[:merchant_id])
          render json: ItemSerializer.new(items)
        end
      end
    end
  end
end
