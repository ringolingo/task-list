Rails.application.routes.draw do

  # verb 'path', to: 'controller#action'
  get '/tasks', to: 'tasks#index', as: 'tasks'
  get '/tasks/new', to: 'tasks#new', as: 'new_task'
  post '/tasks/', to: 'tasks#create'

  get '/tasks/:id', to: 'tasks#show', as: 'task'
  get '/tasks/:id/edit', to: 'tasks#edit', as: 'edit_task'
  patch '/tasks/:id/toggle', to: 'tasks#toggle_complete', as: 'toggle_task'
  patch '/tasks/:id', to: 'tasks#update'
  delete '/tasks/:id', to: 'tasks#destroy'

  root to: 'tasks#index'
end
