class AddDepartmentToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :department, :integer
  end
end
