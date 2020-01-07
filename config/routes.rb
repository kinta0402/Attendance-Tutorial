Rails.application.routes.draw do
  # get 'static_pages/top'
  # ↑ rails g で最初に作られたroutes ⇒ このままだと、Topページ【/】へアクセスした際、railsのwelcome画面に行ってしまうため、
  # root urlのルーティングを下記に変更
  root 'static_pages#top'
  get '/signup', to: 'users#new'

end
