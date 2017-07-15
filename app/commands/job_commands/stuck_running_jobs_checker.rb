module JobCommands
  class StuckRunningJobsChecker
    include SuckerPunch::Job

    def perform
      ActiveRecord::Base.connection_pool.with_connection do
        Job.running.where('start_time <= ?', Time.now - Chamber.env.stuck_running_jobs_timeout).each(&:error)
      end
    end

    def check_in(seconds)
      after(seconds) { perform }
    end
  end
end
