module ApplicationHelper
  def result_count(count)
    count || '?'
  end

  def status_badge(status)
    label = status_bootstrap_mappings(status)
    %(<span class="result result-#{status}">#{status}</span>).html_safe
  end

  def filter_status_badge(status, type, batch_id = nil)
    link_path = type == :batches ? filter_batches_path(status) : batch_filter_path(batch_id, status)
    label = status_bootstrap_mappings(status)
    link_to %(<span class="result result-#{status}">#{status}</span>).html_safe, link_path
  end

  def status_bootstrap_mappings(status)
    mappings = {
      queued:  'info',
      running: 'warning',
      passed:  'success',
      failed:  'important',
      errored: 'inverse'
    }.with_indifferent_access

    mappings.default = 'default'
    mappings[status]
  end

  def testmine_url(job)
    "#{Rails.application.config.testmine_url}/worlds/search?hive_job_id=#{job.id}"
  end

  def user_link(user)
    if user.uid == 'anonymous'
      if Rails.application.config.default_omniauth_provider == :none
        'https://github.com/bbc/hive-scheduler'
      else
        '/auth/' + Rails.application.config.default_omniauth_provider.to_s
      end
    end
  end

  def job_timeout
    Builders::Base::SPECIAL_EXECUTION_VARIABLES[:job_timeout][:default_value]
  end

  def retries
    Builders::Base::SPECIAL_EXECUTION_VARIABLES[:retries][:default_value]
  end

  def jobs_per_queue
    Builders::Base::SPECIAL_EXECUTION_VARIABLES[:jobs_per_queue][:default_value]
  end

  def tests_per_job
    Builders::Base::SPECIAL_EXECUTION_VARIABLES[:tests_per_job][:default_value]
  end
end
