class EventHistory < ApplicationRecord
    default_scope { order(date_of_event: :desc) }
end
