class CreateEventHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :event_histories do |t|
      t.string :event_title, null: false
      t.string :event_text, null: false
      t.date :date_of_event
      t.timestamps
    end
  end
end
