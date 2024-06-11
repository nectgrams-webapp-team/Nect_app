class AddAdminToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :admin, :boolean, default: false
  end
end
