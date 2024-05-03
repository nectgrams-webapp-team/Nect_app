class AddstudentIdToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :student_id, :string
  end
end
