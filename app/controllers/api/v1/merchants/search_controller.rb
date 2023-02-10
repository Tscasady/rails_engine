module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def search
          render json: MerchantSerializer.new(Merchant.search(search_params).first)
            .hash_for_one_record
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
