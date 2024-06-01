class DropTeamsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :teams
  end

  def down
    create_table :teams do |t|
      t.string :name
      t.integer :master_id
      t.string :master_name
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
