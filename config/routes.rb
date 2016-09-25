Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  root 'home#index'

  resources :events do
    collection do
      post 'upload', action: :upload
    end
  end
end
