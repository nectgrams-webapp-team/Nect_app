class RemovePostDayFromActivities < ActiveRecord::Migration[7.1]
  def change
    remove_column :activities, :post_day, :datetime
  end
end
