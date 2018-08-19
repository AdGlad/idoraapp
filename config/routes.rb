Rails.application.routes.draw do
  root 'welcome#index'
  resources :images
  devise_for :users, :controllers => { :registrations => 'registrations' }
  resources :users, :only => [:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
