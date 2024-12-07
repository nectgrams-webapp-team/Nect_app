class ChangeDepartmentFromIntegerToString < ActiveRecord::Migration[7.1]
  def change
    change_column :members, :department, :string
  end
end
