Rails.application.routes.draw do

  # get 'static_pages/top'
  # ↑ rails g で最初に作られたroutes ⇒ このままだと、Topページ【/】へアクセスした際、railsのwelcome画面に行ってしまうため、
  # root urlのルーティングを下記に変更
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # resources :users がﾓｰﾀﾞﾙｳｨﾝﾄﾞｳの為👇に変更 9.3
  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    resources :attendances, only: :update # usersリソースのブロック内に記述している 10.5
  end
end
