class LandmarkAlert < ActiveRecord::Base

  # attributes
  attr_accessible :image, :latitude, :longitude, :height, :detection_date

  # image file
  has_attached_file :image,
    path: "public/files/images/landmarks/:id/:style.:extension",
    url: "/files/images/:id/:style.:extension",
    styles: {
      thumb: '200x200#'
    },
    preserve_files: false

  # validations
  validates_presence_of :latitude
  validates_presence_of :longitude
  validates_presence_of :height
  validates_presence_of :detection_date

  # callbacks
  before_destroy :remove_file


  # callback: before_destroy
  def remove_file
    self.image.clear
  end
end