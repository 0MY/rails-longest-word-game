Rails.application.routes.draw do

 root to: 'lg_word#game'

  get 'game', to: 'lg_word#game'

  get 'score', to: 'lg_word#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
