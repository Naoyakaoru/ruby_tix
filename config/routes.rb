Rails.application.routes.draw do
  root to: 'pages#index'

  resources :pages do
    # 沒id
    collection do
      get :search
      get :footer_page
    end
  end 

  devise_for :users, 
             :controllers => {
               :registrations => "users/registrations", 
               :omniauth_callbacks => "users/omniauth_callbacks"
             }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :users
    resources :activities
  end

  resources :activities, except: [:update] do
    post :join, on: :member
    post :confirm, on: :member  
    delete :cancel, on: :member

    resources :users
    # 主辦方設定票券寫在activity new 頁面 暫定
    resources :ticket_types, :except => [ :show]
    get "/ticket_types/choose_ticket", to: "ticket_types#choose_ticket"
    # 單一活動底下 comment
    resources :comments, only:[:create, :destroy]
  end

  resources :activities_user

  #使用者選則票券頁面
  resources :ticket_types, only:[ :choose_ticket]
  # 訂單成立後顯示個人票券
  resources :tickets, only: [:show]

  resources :orders, only:[:index, :show, :create, :destroy]

  resource :cart, only:[:index, :destroy] do
    collection do
      post :add, path:'add/:id'
    end
  end

end