Rails.application.routes.draw do

  # auth
  post '/signup', to: 'users#create'
  post '/login', to: 'users#login'
  delete '/logout', to: 'users#logout'

  # user routes
  patch '/users/:id', to: 'users#update'
  get '/users/:id', to: 'users#show'
  delete '/users/:id', to: 'users#destroy'

  get '/users', to: 'users#index'
  # product routes
  get '/products', to: 'product#show'
  get '/products/:id', to: 'product#detail'
  post '/add_product', to: 'product#add_product'
end
