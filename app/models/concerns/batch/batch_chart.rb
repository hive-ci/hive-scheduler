class Batch < ActiveRecord::Base
  module BatchChart
    extend ActiveSupport::Concern

    def chart_data
      data = {
        queued: jobs_queued,
        running: jobs_running,
        passed: jobs_passed,
        failed: jobs_failed,
        errored: jobs_errored
      }
      Hive::ChartDataMangler.pie_result_data(data)
    end
  end
end
