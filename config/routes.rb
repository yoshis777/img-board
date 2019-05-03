Rails.application.routes.draw do
  root to: 'topics#index'
  resources :topics, only: [:index, :show, :create, :destroy], shallow: true do
    resources :posts, only: [:show, :create, :edit, :update, :destroy] do
      member do
        post 'edit', to: 'posts#authenticated'
      end
    end
  end

  get 'search', to: 'posts#search'
  get 'mypage', to: 'mypage#index'
  #get 'image_analysis', to: 'images#ocr_analysis'
  get 'errors', to: 'errors#show'

  get '*not_found', to: 'application#render_404'
  post '*not_found', to: 'application#render_404'

end
