Rails.application.routes.draw do
  resources :operators
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'operators#index'

  get '/start', to: 'operators#start'
end
