class API::V1::LandmarkAlertSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :height, :detection_date, :image_url

  def detection_date
    object.detection_date.to_i
  end

  def image_url
    object.image.url
  end
end