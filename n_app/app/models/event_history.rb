class EventHistory < ApplicationRecord
    validates :event_title, presence: true
    validates :event_text, presence: true
    validates :date_of_event, presence: true
    default_scope { order(date_of_event: :desc) }
end
