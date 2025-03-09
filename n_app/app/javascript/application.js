// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "./packs/markdown"

document.addEventListener('turbo:load', () => {
    const file_input = document.getElementById('top_image');
    if (!file_input) return;

    file_input.addEventListener('change', async (event) => {
        const file = event.target.files[0];
        const error_message = document.getElementById("error-message");
        const max_file_size = 5;
        const file_size = file.size / (1024 * 1024)

        if (!file) return;

        if (file_size > max_file_size) {
            error_message.textContent = `エラー：画像のデータ量が大きいです。（${max_file_size}MB 未満）\n現在のサイズ：${file_size.toFixed(2)}MB`;
            error_message.style.display = "block";
            event.target.value = "";
        } else {
            error_message.style.display = "none";
        }
    });
});