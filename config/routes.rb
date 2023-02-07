Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  namespace :api do
    namespace :v1 do
      resources :merchants do
        resources :items, only: [:index], controller: 'merchants/items'
      end

      resources :items do
        member do
          get 'merchant', to: 'items/merchants#show'
        end
      end
    end
  end
end
