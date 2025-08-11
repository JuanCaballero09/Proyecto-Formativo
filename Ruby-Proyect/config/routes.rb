Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root to: "grupos#dashboard"

  get "/buscar", to: "busqueda#index", as: "buscar"
  get 'change_locale/:locale', to: 'application#change_locale', as: :change_locale

  resources :grupos, path: "categorias", only: [ :index, :show ] do
    resources :products, path: "productos", only: [ :index, :show ], module: :grupos
  end

  resources :products, path: "productos", only: [:index] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets

  resource :carrito, only: [:show] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
  resources :carrito_items, only: [ :create, :update, :destroy ] do
    member do
      put :incrementar
    end
  end # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets

  resources :orders, only: [ :create, :show ]


  # resources :pedidos, only: [:create] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
  namespace :dashboard do
    root to: "dashboard#index"
    resources :grupos, path: "grupos"
    resources :ingredientes
    resources :banners
    resources :orders
    resources :products, path: "productos" do
      member do
        patch :toggle_disponibilidad
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :products, only: [ :index ]
    end
  end
end
