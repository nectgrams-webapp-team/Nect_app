class AddGraduationYearToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :graduation_year, :integer
  end
end
