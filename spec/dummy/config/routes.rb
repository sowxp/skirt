Rails.application.routes.draw do

  mount Skirt::Engine => "/", as: 'skirt'

  resources :amazon_payments do
    collection do
      get 'login'
    end
  end

end
