Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'portfolios#index'
  resources :portfolios do
    resources :stocks, only: [:new, :create]
    get '/stocks/fetch_stock', to: 'stocks#fetch_stock'
  end

end
