class Batch < ActiveRecord::Base
  module BatchAssociations
    extend ActiveSupport::Concern

    included do
      belongs_to :project, with_deleted: true
      has_one    :script, through: :project
      has_many   :job_groups, dependent: :destroy
      has_many   :jobs, through: :job_groups
      has_many   :project_assets, through: :project, foreign_key: 'version', source: :assets

      has_many   :test_cases, through: :project
      has_many   :batch_assets
    end
  end
end
