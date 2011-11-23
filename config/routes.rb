SoftLaunch::Engine.routes.draw do
  resources :soft_launch, only: [:show,:update],path: ""
end
