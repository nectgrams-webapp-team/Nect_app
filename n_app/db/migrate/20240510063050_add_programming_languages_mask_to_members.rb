class AddProgrammingLanguagesMaskToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :learning_programming_languages, :bigint, default: 0
  end
end
