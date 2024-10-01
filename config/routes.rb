# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Authentication
  scope :auth do
    get '/check', to: 'auth#check'
    get '/refresh', to: 'auth#refresh'
    post '/signin', to: 'auth#signin'
    delete '/signout', to: 'auth#signout'
    post '/signup', to: 'auth#signup'
  end

  # Users
  scope :user do
    delete '/', to: 'user#delete'
  end

  ### App
  get '/error', to: 'application#error'
  get '/heartbeat', to: 'application#heartbeat'

  # ("/")
  root 'application#index'
end
