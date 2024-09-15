document.addEventListener('turbo:load', () => {
  attachRadioListeners();
  checkAndGenerateOptions();
});

document.addEventListener('DOMContentLoaded', (event) => {
  attachRadioListeners();
  checkAndGenerateOptions();
});

function attachRadioListeners() {
  document.querySelectorAll('input[type=radio][name="member[department]"]').forEach((radio) => {
    radio.addEventListener('change', (e) => {
      const selectedDepartment = e.target.value;
      const selectedGrade = document.querySelector('input[type=radio][name="member[grade]"]:checked')?.value;
      generateAdditionalOptions(selectedDepartment, selectedGrade);
    });
  });

  document.querySelectorAll('input[type=radio][name="member[grade]"]').forEach((radio) => {
    radio.addEventListener('change', (e) => {
      const selectedGrade = e.target.value;
      const selectedDepartment = document.querySelector('input[type=radio][name="member[department]"]:checked')?.value;
      generateAdditionalOptions(selectedDepartment, selectedGrade);
    });
  });
}

function checkAndGenerateOptions() {
  const selectedRadioDepartment = document.querySelector('input[type=radio][name="member[department]"]:checked');
  const selectedRadioGrade = document.querySelector('input[type=radio][name="member[grade]"]:checked');
  if (selectedRadioDepartment && selectedRadioGrade) {
    generateAdditionalOptions(selectedRadioDepartment.value, selectedRadioGrade.value);
  }
}

function generateAdditionalOptions(department, grade) {
  let optionsContainer = document.getElementById('additional-options');
  const selectedCourse = optionsContainer.dataset.selectedCourse; // Get the selected course
  optionsContainer.innerHTML = ''; // Clear previous options

  if (grade === '1年生') {
    const disableRadioOption = `
      <div class="form-check">
        <input class="form-check-input" type="radio" name="member[course]" value="" checked>
        <label class="form-check-label">コース選択中</label>
      </div>
    `;
    optionsContainer.insertAdjacentHTML('beforeend', disableRadioOption);
    return;
  }

  let options = [];

  if (department === '情報工学科') {
    options = [
      { value: 'AI戦略コース', label: 'AI戦略コース' },
      { value: 'IoTシステムコース', label: 'IoTシステムコース' },
      { value: 'ロボット開発コース', label: 'ロボット開発コース' },
    ];
  } else if (department === 'デジタルエンタテインメント学科') {
    options = [
      { value: 'ゲームプロデュースコース', label: 'ゲームプロデュースコース' },
      { value: 'CGアニメーションコース', label: 'CGアニメーションコース' },
    ];
  }

  options.forEach(option => {
    const isChecked = option.value === selectedCourse ? 'checked' : '';
    const radioOption = `
      <div class="form-check">
        <input class="form-check-input" type="radio" name="member[course]" value="${option.value}" ${isChecked}>
        <label class="form-check-label">${option.label}</label>
      </div>
    `;
    optionsContainer.insertAdjacentHTML('beforeend', radioOption);
  });
}
