class AddGameenginesToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :learning_game_engines, :integer, after: :learning_libraries, default: 0
  end
end
