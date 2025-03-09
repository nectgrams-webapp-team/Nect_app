class AddFrameworksToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :learning_frameworks, :bigint, after: :learning_programming_languages, default: 0
  end
end
