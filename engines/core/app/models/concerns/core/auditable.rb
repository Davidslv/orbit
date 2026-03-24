module Core
  module Auditable
    extend ActiveSupport::Concern

    included do
      before_create :set_created_by, if: -> { respond_to?(:created_by) }
      before_update :set_updated_by, if: -> { respond_to?(:updated_by) }
    end

    private

    def set_created_by
      self.created_by ||= Current.user&.id if defined?(Current) && Current.respond_to?(:user)
    end

    def set_updated_by
      self.updated_by = Current.user&.id if defined?(Current) && Current.respond_to?(:user)
    end
  end
end
