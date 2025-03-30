// CSRFトークンの取得
const getCsrfToken = () => {
    const meta_elem = document.querySelector("meta[name='csrf-token']");
    if (!meta_elem) throw new Error("meta[name='csrf-token'] is not found.\nCSRFトークンが取得できません。");

    const csrf_token = meta_elem.content;
    if (!csrf_token) throw new Error("CSRF token is not set.\nCSRFトークンが無効です。");

    return csrf_token;
};

// プレビュー表示
const preview = async (content, t) => {
    const response = await fetch('/api/v1/activities/preview', {
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': t
        },
        method: 'POST',
        body: JSON.stringify({content})
    });

    if (!response.ok) throw new Error('適切なレスポンスを取得できませんでした。');
    return await response.json();
};

const updatePreview = async () => {
    const edit_area = document.getElementById('article_markdown_content')
    const preview_area = document.getElementById('preview')

    if (!edit_area || !preview_area) return

    try {
        const token = getCsrfToken();
        const data = await preview(edit_area.value, token);
        preview_area.innerHTML = data.content;
    } catch (error) {
        console.error('Error occurred while updating preview:\n', error);
        preview_area.innerHTML = "エラーが発生しました。\nもう一度やり直してください。";
    }
};

//`setTimeout` を制御するためのグローバル変数
let previewTimeout;

const handlePreviewUpdate = async () => {
    // console.log("⌨️ キー入力検知！");

    // ✅ すでにセットされた `setTimeout` がある場合はクリアして上書き
    clearTimeout(previewTimeout);

    // ✅ 2000ms 後に `updatePreview()` を実行する `setTimeout` をセット
    previewTimeout = setTimeout(() => {
        // console.log("🕒 updatePreview 実行！");
        updatePreview();
    }, 800);
};

// プレビュー機能
//初回ロード時
document.addEventListener('turbo:load', async () => {
    await updatePreview(); // ✅ 初回の `updatePreview()` を1回だけ実行
}, {once: true});

document.addEventListener('turbo:load', () => {
    const edit_area = document.getElementById('article_markdown_content');
    if (!edit_area) return;

    // console.log("✏️ キー入力のイベントを登録");

    // ✅ 既存の `keyup` イベントを削除してから追加（念のための保険）
    edit_area.removeEventListener('keyup', handlePreviewUpdate);
    edit_area.addEventListener('keyup', handlePreviewUpdate);
});


// コードのコピー機能
const copy = async (e) => {
    const code = e.closest('.highlight-wrap')?.querySelector('.rouge-code');
    // console.log(code);
    if (!code) throw new Error("Code block not found.\nコードブロックが見つかりません。");
    await navigator.clipboard.writeText(code.textContent);

    const original_text = e.innerText;
    e.innerText = 'Copied!';

    setTimeout(() => (e.innerText = original_text), 2500);
};

async function copyHandler(event) {
    try {
        await copy(event.currentTarget); // event.target → event.currentTarget に変更
    } catch (error) {
        console.error("Failed to copy:", error);
    }
}

// ボタンにイベントリスナーを設定
document.addEventListener('turbo:load', () => {
    document.querySelectorAll(".copy-btn").forEach((button) => {
        button.addEventListener("click", copyHandler, {once: true});
    });
});

// 画像のドラッグ&ドロップ挿入機能
window.addEventListener('turbo:load', () => {
    const drag_drop_area = document.getElementById('article_markdown_content');
    if (!drag_drop_area) return

    // カーソル位置に保存された画像のURLを挿入する関数
    const insertAtCursor = (drag_drop_area, text) => {
        const start_pos = drag_drop_area.selectionStart;
        const end_pos = drag_drop_area.selectionEnd;
        const before_text = drag_drop_area.value.substring(0, start_pos);
        const after_text = drag_drop_area.value.substring(end_pos, drag_drop_area.value.length);

        drag_drop_area.value = before_text + text + after_text;
        drag_drop_area.selectionStart = drag_drop_area.selectionEnd = start_pos + text.length;
    };

    drag_drop_area.addEventListener("dragover", (event) => {
        event.preventDefault();
        drag_drop_area.style.background = "#444444";
    });
    drag_drop_area.addEventListener("dragleave", () => {
        drag_drop_area.style.background = "white";
    }, {once: true});

    drag_drop_area.addEventListener("drop", async (event) => {
        event.preventDefault();
        drag_drop_area.style.background = "white";

        const file = event.dataTransfer.files[0];
        const form_data = new FormData();
        const token = getCsrfToken()

        if (!file || !file.type.startsWith("image/")) {
            alert("画像ファイルのみアップロード可能です。\n( .jpg .png .jpeg )");
            return;
        }

        const max_file_size = 8;
        // MB単位
        const file_size = file.size / (1024 * 1024);

        if (file_size > max_file_size) {
            alert(`画像のデータ量が大きいです。\n${max_file_size}MB 未満の画像を利用してください。\n（現在のサイズ: ${file_size.toFixed(2)}MB）`);
            return;
        }

        form_data.append("image", file);
        try {
            const response = await fetch('/api/v1/activities/upload', {
                method: 'POST',
                body: form_data,
                headers: {'X-CSRF-Token': token},
            });

            if (!response.ok) {
                const errorData = await response.json();
                alert(`画像アップロードに失敗しました: ${errorData.message}`);
            }

            const data = await response.json();
            const image_url = data.url;

            // Markdown 形式で `drag_drop_area` に画像を挿入
            const markdown_image = `![画像](${image_url})\n`;
            drag_drop_area.focus();
            insertAtCursor(drag_drop_area, markdown_image);

            // プレビューに表示
            const edit_area = document.getElementById('article_markdown_content');
            const preview_area = document.getElementById('preview');

            setTimeout(async () => {
                const data = await preview(edit_area.value, token);
                preview_area.innerHTML = data.content;
            }, 1000);

        } catch {
            console.error("画像アップロードエラー");
        }
    });
});















