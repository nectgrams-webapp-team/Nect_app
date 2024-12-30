class ChangeDepartmentFromIntegerToString < ActiveRecord::Migration[7.1]
  def up
    rename_column :members, :department, :department_integer_type
    add_column :members, :department, :string

    Member.reset_column_information

    Member.find_each do |member|
      case member.department_integer_type
      when 1
        member.update_column(:department, "information_technology")
      when 2
        member.update_column(:department, "digital_entertainment")
      else
        member.update_column(:department, nil)
      end
    end

    remove_column :members, :department_integer_type
  end

  def down
    rename_column :members, :department, :department_string_type
    add_column :members, :department, :integer

    Member.reset_column_information

    Member.find_each do |member|
      case member.department_string_type
      when "information_technology"
        member.update_column(:department, 1)
      when "digital_entertainment"
        member.update_column(:department, 2)
      else
        member.update_column(:department, nil)
      end
    end

    remove_column :members, :department_string_type
  end
end
