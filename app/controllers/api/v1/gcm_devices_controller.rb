class Api::V1::GcmDevicesController < Api::V1::BaseController

  # POST /gcm_devices
  #
  # gcm_device[registration_id]
  def create
    if params[:gcm_device].present? && params[:gcm_device][:registration_id].present?
      dev = current_resource_owner.gcm_devices.where(registration_id: params[:gcm_device][:registration_id]).first
      if dev
        render json: dev, serializer: ::Api::V1::GcmDeviceSerializer, status: :ok
      else
        dev = Gcm::Device.find_by_registration_id(params[:gcm_device][:registration_id])
        if dev
          render json: { error: { code: 1, message: "Registration id #{registration_id} is already in use." } }, status: :forbidden
        else
          dev = Gcm::Device.create(registration_id: params[:gcm_device][:registration_id])
          current_resource_owner.gcm_devices << dev
          current_resource_owner.save
          render json: dev, serializer: ::Api::V1::GcmDeviceSerializer, status: :ok
        end
      end
    else
      render json: { error: { code: 1, message: 'gcm_device[registration_id] missing.' } }, status: :bad_request
    end
  end


  # GET /gcm_devices/:id
  #
  # :id > registration_id
  def show
    if params[:gcm_device].present? && params[:gcm_device][:registration_id].present?
      dev = current_resource_owner.gcm_devices.where(registration_id: params[:gcm_device][:registration_id]).first
    end

    if dev
      render json: dev, serializer: ::Api::V1::GcmDeviceSerializer, status: :ok
    else
      render json: { error: { code: 1, message: "Registration id #{registration_id} not found." } }, status: :not_found
    end
  end

end