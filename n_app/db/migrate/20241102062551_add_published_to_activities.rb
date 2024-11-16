class AddPublishedToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :published, :boolean, default: true, null: false
  end
end
