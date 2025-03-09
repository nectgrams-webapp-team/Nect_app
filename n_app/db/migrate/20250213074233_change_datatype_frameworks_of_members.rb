class ChangeDatatypeFrameworksOfMembers < ActiveRecord::Migration[7.1]
  def up
    change_column :members, :learning_frameworks, :integer
  end

  def down
    change_column :members, :learning_frameworks, :bigint
  end
end
