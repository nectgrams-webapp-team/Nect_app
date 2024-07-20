class ChangeAdminToBeEnumInMembers < ActiveRecord::Migration[7.1]
  def up
    rename_column :members, :admin, :member_role
    change_column :members, :member_role, :integer, default: 0;
  end
  
  def down
    rename_column :members, :member_role, :admin
    change_column :members, :admin, :boolean, default: false
  end
end
