Billing::Engine.routes.draw do
  resources :invoices, only: [:index, :show]
  resources :subscriptions, only: [:index, :show]

  namespace :api do
    namespace :v1 do
      resources :invoices, only: [:index, :show]
    end
  end
end
