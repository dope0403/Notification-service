require 'sidekiq/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  resources :entries
  resources :orders

  mount Sidekiq::Web => '/sidekiq'

  resources :meetings, only: [:create, :update]
  resource :orders, only: [:create]

  post '/entry-approval', to: "entries#entry_approval"
  post '/', to: "entries#get_slack_payload"
end
