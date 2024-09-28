class AddCourseToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :course, :string
  end
end
