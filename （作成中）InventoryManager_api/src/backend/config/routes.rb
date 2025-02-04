Rails.application.routes.draw do
  get '/home', to: 'home#index'
  post '/login', to: 'auth#login'
  get '/users', to: 'users#all'
  resources :products do
    patch 'update_stock', on: :member  # /products/:id/update_stock というパスに対応
    collection do
      get '/export_excel', to: 'get_excel#export_excel'
      post '/jancodeSearch', to: 'get_jancode#jancodeSearch'
    end
  end
end