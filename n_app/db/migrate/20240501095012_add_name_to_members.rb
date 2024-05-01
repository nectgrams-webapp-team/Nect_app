class AddNameToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :name, :string
  end
end
