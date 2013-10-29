class CreateLandmarkAlerts < ActiveRecord::Migration
  def up
    create_table :landmark_alerts do |t|
      t.float :latitude, precision: 64, scale: 50
      t.float :longitude, precision: 64, scale: 50
      t.float :height, precision: 64, scale: 50
      t.datetime :detection_date
      t.timestamps
    end
    add_attachment :landmark_alerts, :image
  end

  def down
    remove_attachment :landmark_alerts, :image
    drop_table :landmark_alerts
  end
end
