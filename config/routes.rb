Rails.application.routes.draw do



  get 'search/search'
  devise_for :admins, controllers: {
    sessions:    'admin/sessions',
    passwords:     'admin/passwords',
    registrations: 'admin/registrations'
  }

   scope module: :public do
    root "homes#top"
    get "/about" => "homes#about"
    get "customers/my_page" => "customers#show", as: "mypage"
    get 'customers/edit' => 'customers#edit', as: 'edit'
    patch 'customers/' => 'customers#update', as: 'customers'
    get "customers/unsubscribe" => "customers#unsubscribe"
    get "orders/complete" => "orders#complete", as: "complete"
    post "orders/confirm" => "orders#confirm"
    get "orders/confirm" => "orders#error"
    patch "customers/withdraw" => "customers#withdraw"
    delete "cart_items/destroy_all" => "cart_items#destroy_all"
    resources :items, only: [:index, :show]
    resources :cart_items, only: [:create, :update, :destroy]
    resources :cart_items, only: [:index]
    resources :orders, only: [:new, :create, :index, :show]
    resources :addresses, only: [:index, :create, :edit, :update, :destroy]
    get "search" => "searches#search"
  end

  devise_for :customers, controllers: {
    sessions: 'public/sessions',
    passwords: 'public/passwords',
    registrations: 'public/registrations'
  }


    namespace :admin do

    root :to => "orders#index"
    get "/search" => "orders#search"
    resources :customers, only: [:index, :show, :edit, :update]
    resources :items, except: [:destroy]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :orders, only: [:show, :update] do
    resources :order_details, only: [:update]
    end
  end



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html



end
