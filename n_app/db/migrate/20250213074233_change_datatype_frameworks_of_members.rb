class ChangeDatatypeFrameworksOfMembers < ActiveRecord::Migration[7.1]
  def change
    change_column :members, :learning_frameworks, :int
  end
end
