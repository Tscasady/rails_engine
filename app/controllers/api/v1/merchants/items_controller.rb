module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController
        def index
          render json: Item.all
        end
      end
    end
  end
end
