class API::V1::LandmarkAlertSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :height, :detection_date, :image_path

  def image_path
    "http://placekitten.com/g/200/300"
  end

  def detection_date
    object.detection_date.to_i
  end

  def image_url
    object.image.url
  end
end