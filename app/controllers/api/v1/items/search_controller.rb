module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def search
          if params[:name]
            render json: ItemSerializer.new(Item.name_search(search_params).first)
              .hash_for_one_record
          else
            render json: ItemSerializer.new(Item.price_search(search_params).first)
              .hash_for_one_record
          end
        end
        
        def search_all
          if params[:name]
            render json: ItemSerializer.new(Item.name_search(search_params))
          else
            render json: ItemSerializer.new(Item.price_search(search_params))
          end
        end

        private

        def search_params
          ParamsFilter.new(params).filter
 #    raise ActionController::ParameterMissing if query.keys.length > 1 && query.include?(:name)
 #    query.require(:name)
 # || query.require(:min_price) && query.require(:max_price)
        end
      end
    end
  end
end
