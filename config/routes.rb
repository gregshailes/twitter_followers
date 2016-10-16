Rails.application.routes.draw do

    root 'application#index'

    post 'application/get_followers', to: 'application#get_followers'

end
