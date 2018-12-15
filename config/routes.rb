Rails.application.routes.draw do
  resources :users
  get '/login_form', to: 'auth#login_form', as: :login_form
  post '/login', to: 'auth#login', as: :login
  get '/logout', to: 'auth#logout', as: :logout
  root :controller => 'application', :action => 'index'
  match '*unmatched_route', via: :all, to: 'application#raise_not_found', format: false
end
