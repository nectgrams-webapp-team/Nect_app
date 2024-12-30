# frozen_string_literal: true
class Api::V1::MembersController < ApplicationController
  def courses_by_department
    departments = params[:departments]
    department_courses = {}
    departments.each do |department|
      department_courses[department] = {}
      courses = Member::DEPARTMENT_COURSES[department.to_sym] || []
      courses.each do |course|
        department_courses[department][course] = Member.human_attribute_name("courses.#{course}")
      end
    end

    render json: department_courses
  end
end
