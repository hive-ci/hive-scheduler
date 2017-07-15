module Builders
  class ManualBuilder < Builders::Base
    module Manifest
      BUILDER_NAME  = 'manual_builder'.freeze
      FRIENDLY_NAME = 'Manual'.freeze
      BATCH_BUILDER = Builders::ManualBuilder::BatchBuilder
    end
  end
end
