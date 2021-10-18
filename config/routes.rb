Rails.application.routes.draw do
  get 'users/new'

 root 'static_pages#home'
  # _path form for unless doing redirects, then use _url ( full URL required by HTTP )
  #get 'static_pages/home'
  #get 'static_pages/help'
  #get 'static_pages/about'
  #get 'static_pages/contact'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
   
  resources :users # get routing for users
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
