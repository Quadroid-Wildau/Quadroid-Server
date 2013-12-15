QuadroidServer::Application.routes.draw do

  # auth and oauth 2 provider
  devise_for :users
  use_doorkeeper

  # api accept header:
  # application/vnd.quadroid-server-vX+json
  # X = version number

  # V1.0
  constraints ApiVersion.new(1) do
    scope module: :api do
      scope module: :v1 do
        # controllers in app/controllers/api/v1

        resources :gcm_devices, only: [:create, :show]
        resources :landmark_alerts, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end
end
