class UserGcmDeviceConnection < ActiveRecord::Base

  # attributes
  attr_accessible :user, :gcm_device

  # relations
  belongs_to :user, class_name: 'User'
  belongs_to :gcm_device, class_name: 'Gcm::Device'

end