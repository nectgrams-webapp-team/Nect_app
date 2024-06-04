// Our lord and saviour ChatGPT has blessed us with this piece of code
// If someone who knows how javascript scripts work, feel free to change it!

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
      generateAdditionalOptions(selectedDepartment);
    });
  });
}

function checkAndGenerateOptions() {
  const selectedRadio = document.querySelector('input[type=radio][name="member[department]"]:checked');
  if (selectedRadio) {
    generateAdditionalOptions(selectedRadio.value);
  }
}

function generateAdditionalOptions(department) {
  let optionsContainer = document.getElementById('additional-options');
  const selectedCourse = optionsContainer.dataset.selectedCourse; // Get the selected course
  optionsContainer.innerHTML = ''; // Clear previous options

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
