Rails.application.routes.draw do
  resources :users
  root :controller => 'application', :action => 'index'
  match '*unmatched_route', via: :all, to: 'application#raise_not_found', format: false
end
