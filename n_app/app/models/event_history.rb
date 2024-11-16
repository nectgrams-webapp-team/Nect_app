class EventHistory < ApplicationRecord
    validates :event_title, :event_text, :date_of_event, presence: true
    default_scope { order(date_of_event: :desc) }
end
