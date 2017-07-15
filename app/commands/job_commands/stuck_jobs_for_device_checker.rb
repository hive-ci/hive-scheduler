module JobCommands
  class StuckJobsForDeviceChecker < Imperator::Command
    attribute :device_id, Integer

    validates_presence_of :device_id

    action do
      Job.running.where(device_id: device_id).each(&:error)
    end
  end
end
