class CreateTeamMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :team_members do |t|
      t.integer :team_id
      t.integer :member_id
      t.boolean :approved
      t.timestamps
    end
  end
end
