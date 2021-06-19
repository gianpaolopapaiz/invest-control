Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'portfolios#index'
  resources :portfolios do
    resources :stocks, only: [:new, :create, :index]
    resources :funds, only: [:new, :create, :index]
    get '/stocks/choose_stock', to: 'stocks#choose_stock'
    get '/funds/choose_fund', to: 'funds#choose_fund'
  end
  get '/portfolios/:id/update_stocks_price', to: 'stocks#update_stocks_price', as: 'update_stocks_price'
  get '/portfolios/:id/update_funds_price', to: 'funds#update_funds_price', as: 'update_funds_price'
  resources :stocks, only: [:edit, :update, :destroy]
  resources :funds, only: [:edit, :update, :destroy]
end
