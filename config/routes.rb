Rails.application.routes.draw do
  namespace :auth do
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
  end

  post '/signin', to: 'users#create'
end
