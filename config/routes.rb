Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'portfolios#index'
  resources :portfolios do
    resources :portfolio_stocks, only: [:new, :create]
    
  end

end
