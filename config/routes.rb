Rails.application.routes.draw do

  get 'color', to: 'queued_colors#color', as: 'color'

  resources :queued_colors, only: [:index, :create]

  resources :displayed_colors, only: [:index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
