class AddLibrariesToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :learning_libraries, :integer, after: :learning_frameworks, default: 0
  end
end
