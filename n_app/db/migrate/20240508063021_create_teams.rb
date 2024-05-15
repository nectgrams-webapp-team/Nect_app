class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.text :introduction
      t.integer :master_id
      t.timestamps
    end
  end
end
