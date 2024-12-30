class UpdateCourses < ActiveRecord::Migration[7.1]
  def up
    rename_column :members, :course, :course_old
    add_column :members, :course, :string

    Member.reset_column_information

    Member.find_each do |member|
      case member.course_old
      when "AI戦略コース"
        member.update_column(:course, "ai_strategy")
      when "IoTシステムコース"
        member.update_column(:course, "iot_systems")
      when "ロボット開発コース"
        member.update_column(:course, "robotics_development")
      else
        # do nothing
      end
    end

    remove_column :members, :course_old
  end

  def down
    rename_column :members, :course, :course_old
    add_column :members, :course, :string

    Member.reset_column_information

    Member.find_each do |member|
      case member.course_old
      when "ai_strategy"
        member.update_column(:course, "AI戦略コース")
      when "iot_systems"
        member.update_column(:course, "IoTシステムコース")
      when "robotics_development"
        member.update_column(:course, "ロボット開発コース")
      else
        # do nothing
      end
    end

    remove_column :members, :course_old
  end
end
