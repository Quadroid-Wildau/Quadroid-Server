# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :landmark_alert do
    # image File.new(Rails.root + 'spec/factories/landmark_images/example.png')
    latitude 52.326003
    longitude 13.626553
    height 100.0
    detection_date Time.now
  end
end
