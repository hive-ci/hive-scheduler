class Job < ActiveRecord::Base
  module JobResult
    extend ActiveSupport::Concern

    def calculate_result
      # Default to errored if no results have been reported
      self.result = 'errored'

      # Set initial result using the exit value
      if exit_value
        self.result = (exit_value.zero? ? 'passed' : 'failed')
      end

      # If we've got counts, attempt to be a bit smarter
      if errored_count.to_i > 0
        self.result = 'errored'
      elsif failed_count.to_i > 0
        self.result = 'failed'
      elsif passed_count.to_i > 0
        self.result = 'passed'
      end

      self.queued_count = 0
      self.running_count = 0
      save
    end

    def move_queued_to_running
      test_results.each { |tr| tr.update(status: 'running') } if test_results
      self.running_count = queued_count
      self.queued_count  = 0
      save
    end

    def move_all_to_errored
      test_results.each { |tr| tr.update(status: 'errored') } if test_results
      self.errored_count = queued_count.to_i + running_count.to_i
      self.running_count = 0
      self.queued_count  = 0
      save
    end
  end
end
