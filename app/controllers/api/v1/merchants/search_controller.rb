module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def search
          render json: MerchantSerializer.new(Merchant.search(params[:name]).first)
        end
        
        def search_all
        end
      end
    end
  end
end
