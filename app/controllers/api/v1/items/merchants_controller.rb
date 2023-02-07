module Api
  module V1
    module Items
      class MerchantsController < ApplicationController
        def show
          render json: MerchantSerializer.new(Item.find(params[:id]).merchant)
        end
      end
    end
  end
end
