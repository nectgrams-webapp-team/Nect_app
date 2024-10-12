class RemoveColumnToMember < ActiveRecord::Migration[7.1]
  def change
    remove_column :members, :grad_year, :integer, null: false, default: 0
  end
end
