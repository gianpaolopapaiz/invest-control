Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'portfolios#index'
  resources :portfolios do
    resources :stocks, only: [:new, :create]
    get '/stocks/choose_stock', to: 'stocks#choose_stock'
    get '/stocks/update_stocks_price', to: 'stocks#update_stocks_price', as: 'update_stocks_price'
  end
  resources :stocks, only: [:destroy]

end
