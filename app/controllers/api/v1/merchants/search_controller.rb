module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def search
          merchant = Merchant.search(search_params).first
          if merchant
            render json: MerchantSerializer.new(merchant)
          else
            render json: { data: {} }
          end
        end
        
        def search_all
          render json: MerchantSerializer.new(Merchant.search(search_params))
        end

        private

        def search_params
          params.require(:name)
        end
      end
    end
  end
end
