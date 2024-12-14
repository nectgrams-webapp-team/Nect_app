class ChangeGradeFromStringToInteger < ActiveRecord::Migration[7.1]
  def up
    rename_column :members, :grade, :grade_string_type
    add_column :members, :grade, :integer

    Member.reset_column_information

    Member.find_each do |member|
      case member.grade_string_type
      when "1"
        member.update_column(:grade, 0)
      when "2"
        member.update_column(:grade, 1)
      when "3"
        member.update_column(:grade, 2)
      when "4"
        member.update_column(:grade, 3)
      when "5"
        member.update_column(:grade, 4)
      else
        member.update_column(:grade, nil)
      end
    end

    remove_column :members, :grade_string_type
  end

  def down
    rename_column :members, :grade, :grade_integer_type
    add_column :members, :grade, :string

    Member.reset_column_information

    Member.find_each do |member|
      case member.grade_integer_type
      when 0
        member.update_column(:grade, "1")
      when 1
        member.update_column(:grade, "2")
      when 2
        member.update_column(:grade, "3")
      when 3
        member.update_column(:grade, "4")
      when 4
        member.update_column(:grade, "5")
      else
        member.update_column(:grade, nil)
      end
    end

    remove_column :members, :grade_integer_type
  end
end
