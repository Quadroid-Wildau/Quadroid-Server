class Api::V1::LandmarkAlertsController < Api::V1::BaseController

  def index
    landmarks = LandmarkAlert.order('detection_date DESC')

    render json: landmarks,
           each_serializer: ::API::V1::LandmarkAlertSerializer,
           status: :ok
  end

  def show

  end

  def create

  end

  def update

  end

  def destroy

  end

end