class Script < ActiveRecord::Base
  module ScriptValidations
    extend ActiveSupport::Concern

    included do
      validates :name, :template, presence: true
      before_validation :strip_carriage_returns
    end

    private

    def strip_carriage_returns
      self.template = template.to_s.delete("\r")
    end
  end
end
