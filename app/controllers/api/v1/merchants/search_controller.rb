module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def search
          require 'pry'; binding.pry
          render json: Merchant.search(params[:query])
        end
        
        def search_all
        end
      end
    end
  end
end
