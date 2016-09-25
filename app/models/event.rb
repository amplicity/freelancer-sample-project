class Event < ActiveRecord::Base
  include Scopes

  def as_json(options = {})
    super(options)
  end
end
