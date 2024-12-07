class ChangeGradeFromStringToInteger < ActiveRecord::Migration[7.1]
  def change
    change_column :members, :grade, :integer
  end
end
