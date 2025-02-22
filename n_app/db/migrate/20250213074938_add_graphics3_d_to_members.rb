class AddGraphics3DToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :learning_graphics_3D, :integer, after: :learning_game_engines, default: 0
  end
end
