class CreateUserGcmDeviceConnections < ActiveRecord::Migration
  def change
    create_table :user_gcm_device_connections do |t|
      t.references :user
      t.references :gcm_device
      t.timestamps
    end
    add_index :user_gcm_device_connections, :user_id
    add_index :user_gcm_device_connections, :gcm_device_id
  end
end
