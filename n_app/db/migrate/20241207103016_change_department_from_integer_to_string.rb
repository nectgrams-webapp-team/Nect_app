class ChangeDepartmentFromIntegerToString < ActiveRecord::Migration[7.1]
  def up
    rename_column :members, :department, :department_integer_type
    add_column :members, :department, :string

    Member.reset_column_information

    Member.find_each do |member|
      case member.department
      when 1
        member.update!(department: "information_technology")
      when 2
        member.update!(department: "digital_entertainment")
      else
        member.update!(department: nil)
      end
    end

    remove_column :members, :department_integer_type
  end

  def down
    rename_column :members, :department, :department_string_type
    add_column :members, :department, :integer

    Member.reset_column_information

    Member.find_each do |member|
      case member.department
      when "information_technology"
        member.update!(department: 1)
      when "digital_entertainment"
        member.update!(department: 2)
      else
        member.update!(department: nil)
      end
    end

    remove_column :members, :department_string_type
  end
end
