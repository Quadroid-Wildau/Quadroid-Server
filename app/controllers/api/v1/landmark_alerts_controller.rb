class Api::V1::LandmarkAlertsController < Api::V1::BaseController

  # GET /landmark_alerts
  def index
    landmarks = LandmarkAlert.order('detection_date DESC')

    render json: landmarks, each_serializer: ::API::V1::LandmarkAlertSerializer, status: :ok, request: request
  end

  # GET /landmark_alerts/:id
  def show
    landmark = LandmarkAlert.find_by_id(params[:id])
    if landmark
      render json: landmark, serializer: ::API::V1::LandmarkAlertSerializer, status: :ok, request: request
    else
      render json: { error: { code: 1, message: 'Could not find landmark alert for passed id.' } }, status: :not_found
    end
  end

  # POST /landmark_alerts
  #
  # params:
  # landmark_alert[image]
  # landmark_alert[latitude]
  # landmark_alert[longitude]
  # landmark_alert[height]
  # landmark_alert[detection_date]
  def create
    landmark_date = params[:landmark_alert][:detection_date].to_i
    detection_date = Time.at(landmark_date) if landmark_date > 0
    landmark = LandmarkAlert.new(params[:landmark_alert].merge( detection_date: detection_date ))
    if landmark.save
      notify_gcm_devices(landmark, :create)
      render json: landmark, serializer: ::API::V1::LandmarkAlertSerializer, status: :ok
    else
      render json: { error: { code: 1, messages: landmark.errors.messages } }, status: :bad_request
    end
  end

  # PUT /landmark_alerts/:id
  #
  # params:
  # landmark_alert[image]
  # landmark_alert[latitude]
  # landmark_alert[longitude]
  # landmark_alert[height]
  # landmark_alert[detection_date]
  def update
    landmark = LandmarkAlert.find_by_id(params[:id])
    landmark.detection_date = DateTime.new(params[:landmark_alert].delete(:detection_date).to_i) if landmark && params[:landmark_alert][:detection_date].present?

    unless landmark
      render json: { error: { code: 1, message: 'Resource not found' } }, status: :not_found
      return
    end

    if landmark.update_attributes(params[:landmark_alert])
      notify_gcm_devices(landmark, :update)
      render json: landmark, serializer: ::API::V1::LandmarkAlertSerializer, status: :ok
    else
      render json: { error: { code: 2, messages: landmark.errors.messages } }, status: :bad_request
    end
  end

  # DELETE /landmark_alerts/:id
  def destroy
    landmark = LandmarkAlert.find_by_id(params[:id])

    if landmark
      id = landmark.id
      landmark.destroy
      render json: { status: { deleted: true, id: id } }, status: :ok
    else
      render json: { error: { code: 1, message: 'Resource not found' } }, status: :not_found
    end
  end


  protected

  def notify_gcm_devices(landmark, action)
    devices = Gcm::Device.all
    devices.each do |device|
      n = Gcm::Notification.new
      n.device = device
      n.collapse_key = "landmark_#{landmark.id}"
      n.delay_while_idle = true
      text = action == :update ? 'Landmark alert updated.' : 'Landmark alert added.'
      n.data = { registration_ids: [device.registration_id], data: { message_text: text, 'lmAlarmId' => landmark.id } }
      n.save
    end

    Gcm::Notification.send_notifications
  end

end