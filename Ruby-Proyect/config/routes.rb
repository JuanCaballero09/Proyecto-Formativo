Rails.application.routes.draw do
  scope "(:locale)", locale: /es|en/ do
    devise_for :users, controllers: { registrations: "users/registrations" }

    root to: "grupos#dashboard"

    get "/buscar", to: "busqueda#index", as: "buscar"

    resources :grupos, path: "categorias", only: [ :index, :show ] do
      resources :products, path: "productos", only: [ :index, :show ], module: :grupos
    end

    resources :products, path: "productos", only: [:index] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets

    resource :carrito, only: [:show] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
    resources :carrito_items, only: [ :create, :update, :destroy ] do
      member do
        put :incrementar
      end
    end

    resources :orders, param: :code, only: [ :show, :create ] do
      resource :payments, path: "payment", only: [ :new, :create ], module: :orders
    end

    post "/wompi/webhook", to: "wompi#webhook"
  end

  # resources :pedidos, only: [:create] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
  namespace :dashboard do
    root to: "dashboard#index"
    resources :grupos, path: "grupos"
    resources :ingredientes
    resources :users
    resources :banners
    resources :orders do
      collection do
        get :employee
      end
      member do
        patch :cambiar_estado
        patch :cancelar
      end
    end
    resources :products, path: "productos" do
      member do
        patch :toggle_disponibilidad # Cambia el nombre aquí
      end
    end
  end

  # API routes
  namespace :api do
    namespace :v1 do
      resources :products, only: [ :index ]
    end
  end
end
