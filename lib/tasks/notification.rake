namespace :notifications do

  desc 'Sample notification'
  task :sample => :environment do |t, args|
    devices = Gcm::Device.all
    devices.each do |device|
      n = Gcm::Notification.new
      n.device = device
      n.collapse_key = 'updates_available'
      n.delay_while_idle = false
      n.data = { registration_ids: [device.registration_id], data: { message_text: 'Sample notification', 'lmAlarmId' => 1 } }
      # lmAlarmId => landmark id
      n.save
    end

    Gcm::Notification.send_notifications
  end

end