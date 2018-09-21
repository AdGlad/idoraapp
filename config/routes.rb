Rails.application.routes.draw do
  resources :labels
  resources :identities
  root 'welcome#index'
  resources :images
  devise_for :users, :controllers => { :registrations => 'registrations' }
  resources :users, :only => [:show]
  get 'identifies/:id', to: 'identifies#show' , :as=> 'identify'
  get 'image_match/:id', to: 'images#match', :as=>'image_match'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
