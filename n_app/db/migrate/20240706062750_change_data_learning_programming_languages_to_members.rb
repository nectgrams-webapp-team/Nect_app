class ChangeDataLearningProgrammingLanguagesToMembers < ActiveRecord::Migration[7.1]
  def change
    change_column :members, :learning_programming_languages, :integer
  end
end
