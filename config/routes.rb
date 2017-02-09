Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'user/sessions',
    registrations: 'user/registrations',
    passwords: 'user/passwords'
  }

  resources :restaurants, only: [:index, :show]
  resources :meals, only: [:index, :show]
end
