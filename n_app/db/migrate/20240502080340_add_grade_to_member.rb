class AddGradeToMember < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :grade, :string
  end
end
