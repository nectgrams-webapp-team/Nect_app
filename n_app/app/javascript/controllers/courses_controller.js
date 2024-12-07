import { Controller } from "@hotwired/stimulus"

let cache = {}

// Connects to data-controller="courses"
export default class extends Controller {
    static targets = ['gradeRadio', 'departmentRadio', 'coursesWrapper'];

    async connect() {
        const grade = this.gradeRadioTargets.find((radio) => radio.checked)?.value;
        const department = this.departmentRadioTargets.find((radio) => radio.checked)?.value;
        if (grade && department) {
            await this.updateCourses(grade, department);
        }
    }

    async selectGrade(event) {
        const grade = event.target.value;
        const department = this.departmentRadioTargets.find((radio) => radio.checked)?.value;
        await this.updateCourses(grade, department);
    }

    async selectDepartment(event) {
        const department = event.target.value;
        const grade = this.gradeRadioTargets.find((radio) => radio.checked)?.value;
        await this.updateCourses(grade, department);
    }

    createRadioButton(name, value, id, labelText, isChecked = false) {
        const radio = document.createElement('input');
        radio.classList.add('form-check-input');
        radio.type = 'radio';
        radio.name = name;
        radio.value = value;
        radio.id = id;
        radio.checked = isChecked;

        const label = document.createElement('label');
        label.classList.add('form-check-label');
        label.htmlFor = id;
        label.textContent = labelText;

        const wrapper = document.createElement('div');
        wrapper.classList.add('form-check');
        wrapper.appendChild(radio);
        wrapper.appendChild(label);

        return wrapper;
    }

    async updateCourses(grade, department) {
        const courses = this.coursesWrapperTarget;
        const checkedCourse = courses.dataset.checkedCourse;

        courses.innerHTML = '';
        courses.innerHTML = '<p>Loading courses...</p>';

        if (grade === 'freshman') {
            courses.innerHTML = '';
            courses.appendChild(this.createRadioButton('member[course]', '', 'member_department_no_course', 'WIP', true));
            return;
        }

        if (department) {
            if (department in cache) {
                courses.innerHTML = '';
                cache[department].forEach((course) => {
                    courses.appendChild(this.createRadioButton('member[course]', course, `member_department_${course}`, course, course === checkedCourse));
                });
            }

            try {
                const response = await fetch(`/members/courses_by_department?department=${encodeURIComponent(department)}`);
                if (!response.ok) {
                    throw new Error(`${response.status}`);
                }

                const data = await response.json();
                cache[department] = data.courses;

                courses.innerHTML = '';
                data.courses.forEach((course) => {
                    courses.appendChild(this.createRadioButton('member[course]', course, `member_department_${course}`, course, course === checkedCourse));
                });
            } catch (error) {
                console.error('Error fetching data;', error);
                courses.innerHTML = '<p>Error: Failed To Load Courses</p>';
            }
        }
    };
}
