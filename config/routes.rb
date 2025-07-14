ScheduledTasksUi::Engine.routes.draw do
  resources :tasks, only: [:index, :show]
  resources :runs, only: [:create, :show] do
    post :pause, on: :member
    post :cancel, on: :member
    post :resume, on: :member
  end
end
