module Scopes
  extend ActiveSupport::Concern
  included do
    scope :not_deleted, -> { where(:is_deleted => false) }
    scope :deleted, -> { where(:is_deleted => true) }
  end
end