class ChangeGradeFromStringToInteger < ActiveRecord::Migration[7.1]
  def up
    rename_column :members, :grade, :grade_string_type
    add_column :members, :grade, :integer

    Member.reset_column_information

    Member.find_each do |member|
      case member.grade
      when "1"
        member.update!(grade: 0)
      when "2"
        member.update!(grade: 1)
      when "3"
        member.update!(grade: 2)
      when "4"
        member.update!(grade: 3)
      when "5"
        member.update!(grade: 4)
      else
        member.update!(grade: nil)
      end
    end

    remove_column :members, :grade_string_type
  end

  def down
    rename_column :members, :grade, :grade_integer_type
    add_column :members, :grade, :string

    Member.reset_column_information

    Member.find_each do |member|
      case member.grade
      when 0
        member.update!(grade: "1")
      when 1
        member.update!(grade: "2")
      when 2
        member.update!(grade: "3")
      when 3
        member.update!(grade: "4")
      when 4
        member.update!(grade: "5")
      else
        member.update!(grade: nil)
      end
    end

    remove_column :members, :grade_integer_type
  end
end
