class AddColumnToMember < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :grad_year, :integer, null: false, default: 0
  end
end
