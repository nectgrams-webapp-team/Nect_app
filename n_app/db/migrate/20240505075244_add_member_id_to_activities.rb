class AddMemberIdToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :member_id, :integer
  end
end
