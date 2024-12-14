module ApplicationHelper
  def grade_translation(grade)
    grade ? Member.human_attribute_name("grades.#{grade}") : Member.human_attribute_name("grades.nil")
  end

  def department_translation(department)
    department ? Member.human_attribute_name("departments.#{department}") : Member.human_attribute_name("grades.nil")
  end

  def course_translation(course)
    course ? Member.human_attribute_name("courses.#{course}") : Member.human_attribute_name("grades.nil")
  end
end
