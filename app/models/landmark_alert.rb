class LandmarkAlert < ActiveRecord::Base

  # attributes
  attr_accessible :image, :latitude, :longitude, :height, :detection_date

  # image file
  has_attached_file :image,
      path: "public/files/images/landmarks/:id/:style.:extension",
      url: "/files/images/:id/:style.:extension",
      styles: {
        thumb: '200x200#'
      }

end
