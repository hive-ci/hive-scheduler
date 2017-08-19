class Job < ActiveRecord::Base
  module JobChart
    extend ActiveSupport::Concern

    def chart_data
      data = {
        queued: queued_count,
        running: running_count,
        passed: passed_count,
        failed: failed_count,
        errored: errored_count
      }
      Hive::ChartDataMangler.pie_result_data(data)
    end
  end
end
