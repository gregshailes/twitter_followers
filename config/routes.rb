Rails.application.routes.draw do

  resources :monkeys
  resources :users
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    root 'application#index'

    post 'application/get_followers', to: 'application#get_followers'

end
