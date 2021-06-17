Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'portfolios#index'
  resources :portfolios do
    resources :stocks, only: [:new, :create, :index]
    get '/stocks/choose_stock', to: 'stocks#choose_stock'
  end
  get '/portfolios/:id/update_stocks_price', to: 'portfolios#update_stocks_price', as: 'update_stocks_price'
  resources :stocks, only: [:edit, :update, :destroy]

end
