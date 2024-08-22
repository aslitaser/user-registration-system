Rails.application.routes.draw do
  root "static_pages#home"

  get "/signup", to: "registrations#new"
  post "/signup", to: "registrations#create"
  get "confirm_email/:token", to: "email_confirmations#confirm", as: "confirm_email"
end
