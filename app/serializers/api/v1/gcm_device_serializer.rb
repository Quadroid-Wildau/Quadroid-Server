class Api::V1::GcmDeviceSerializer < ActiveModel::Serializer
  attributes :registration_id, :last_registered_at

end