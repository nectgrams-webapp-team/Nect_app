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
            courses.appendChild(this.createRadioButton('member[course]', 'no_course', 'member_department_no_course', 'NULL_VALUE', true));
            return;
        }

        if (department) {
            const courseRadio = (courseValue, courseLabel) => {
                return this.createRadioButton('member[course]', courseValue, `member_department_${courseValue}`, courseLabel, courseValue === checkedCourse);
            }

            if (department in cache) {
                courses.innerHTML = '';
                for (const [value, label] of Object.entries(cache[department])) {
                    courses.appendChild(courseRadio(value, label));
                }

                return;
            }

            try {
                const query = `/api/v1/members/courses_by_department?departments[]=${encodeURIComponent(department)}`;
                const response = await fetch(query);
                if (!response.ok) {
                    throw new Error(`${response.status}`);
                }

                const data = await response.json();
                cache[department] = data[department];

                courses.innerHTML = '';
                for (const [value, label] of Object.entries(data[department])) {
                    courses.appendChild(courseRadio(value, label));
                }
            } catch (error) {
                console.error('Error in fetching data from the api: ', error);
                courses.innerHTML = '<p>Error: Failed To Load Courses</p>';
            }
        }
    };
}
