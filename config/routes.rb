Skirt::Engine.routes.draw do


  resource :amazon_order_reference do
    post :authorize
  end

end
