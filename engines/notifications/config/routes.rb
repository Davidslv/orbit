Notifications::Engine.routes.draw do
  resources :notifications, only: [:index, :show] do
    member do
      patch :read
    end
    collection do
      patch :read_all
    end
  end
end
