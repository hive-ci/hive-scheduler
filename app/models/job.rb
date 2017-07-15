class Job < ActiveRecord::Base
  include JobValidations
  include JobStateMachine
  include JobChart
  include JobArtifacts
  include JobAssociations
  include Cachethod
  include JobResult
  include JobDevice
  include JobTestCases

  class << self
    def state_counts
      @counts = where('id IN (?)', Job.last(1000)).group(:state, :result).count.each_with_object({}) do |i, h|
        if i.first.first == 'complete'
          h[i.first.second] = i.second
        elsif %w[preparing running analyzing].include? i.first.first
          h['running'] = h['running'].to_i + i.second
        else
          h[i.first.first] = i.second
        end
      end

      @counts.default = 0
      @counts
    end
  end

  cache_class_method :state_counts, expires_in: 5.minutes

  serialize :execution_variables, JSON
  serialize :reservation_details, JSON

  self.per_page = 20

  scope :active, -> {
    joins('LEFT JOIN jobs AS replacement_jobs ON jobs.id = replacement_jobs.original_job_id')
      .where(replacement_jobs: { original_job_id: nil })
  }
  scope :completed, -> { where("state in ('complete', 'errored')") }
  scope :completed_without_error, -> { where(state: 'complete').where('result <> "errored"') }
  scope :queued, -> { where(state: 'queued') }
  scope :running, -> { where(state: %w[preparing running analyzing]) }
  delegate :queue_name, to: :job_group

  # Filter jobs for today's SLO targets
  scope :slo_core_hours, -> {
    day = 1.day.ago
    where('jobs.created_at < ? AND jobs.created_at >= ?',
          day.change(hour: 17, minute: 0, second: 0),
          day.change(hour: 9, minute: 0, second: 0))
  }

  def retry
    if can_retry?
      if !retriable_test_cases.empty?
        total_test_count = retriable_test_cases.count
      else
        total_test_count = passed_count.to_i + failed_count.to_i + errored_count.to_i
        # If there is a zero test count, set it to nil, i.e. unknown
        total_test_count = nil if total_test_count.zero?
      end

      self.replacement = Job.new(
        job_name:            job_name,
        queued_count:        total_test_count,
        retry_count:         retry_count + 1,
        job_group:           job_group,
        original_job:        self,
        execution_variables: execution_variables
      )

      replacement.tap do |job|
        retriable_test_cases.each do |tc|
          job.associate_test_case_result(name: tc.name,
                                         urn: tc.urn,
                                         status: 'notrun')
        end
      end
    end
  end

  def status
    result || state
  end

  def retried?
    replacement.present?
  end

  def all_tests_passing?
    failed_count.to_i.zero? && errored_count.to_i.zero? && passed_count > 0
  end

  def can_retry?
    %w[failed errored].include?(status) unless retried?
  end

  def can_cancel?
    %w[queued reserved].include?(status)
  end

  # TODO: replace this with a more elegant and non tests or test_rail specific
  # implementation e.g: something that can deal with cuke tags, etc, also
  # will leave until further requirements and design is understood
  def tests
    execution_variables['tests']
  end

  def reservation_valid?
    (Time.now - reserved_at) < Chamber.env.job_reservation_timeout if reserved?
  end

  private

  # TODO: replace this with a more elegant and non tests or test_rail specific
  # implementation e.g: something that can deal with cuke tags, etc, also
  # will leave until further requirements and design is understood
  def run_id
    job_group.execution_variables['run_id']
  end
end
