class Api::V1::LandmarkAlertsController < Api::V1::BaseController

  def index
    landmarks = LandmarkAlert.order('detection_date DESC')

    render json: landmarks,
           each_serializer: ::API::V1::LandmarkAlertSerializer,
           status: :ok
  end

  def show
    landmark = LandmarkAlert.find_by_id(params[:id])
    if landmark
      render json: landmark,
             serializer: ::API::V1::LandmarkAlertSerializer,
             status: :ok
    else
      render json: { error: { code: 1, message: 'Could not find landmark alert for passed id.' } }, status: :not_found
    end
  end

  def create

  end

  def update

  end

  def destroy

  end

end