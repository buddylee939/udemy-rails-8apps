Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :pics do
    member do
      put 'like', to: 'pics#upvote'
      put 'unlike', to: 'pics#downvote'
    end
  end
  root 'pics#index'
end
