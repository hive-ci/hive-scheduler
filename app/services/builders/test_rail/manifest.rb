module Builders
  class TestRail < Builders::Base
    module Manifest
      BUILDER_NAME    = 'test_rail'.freeze
      FRIENDLY_NAME   = 'Test Rail Plan'.freeze
      BATCH_BUILDER   = Builders::TestRail::BatchBuilder
    end
  end
end
