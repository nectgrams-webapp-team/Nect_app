// プレビュー機能
window.addEventListener('turbo:load', () => {
    const editArea = document.getElementById('article_markdown_content') // テキストエリア
    const previewArea = document.getElementById('preview') // プレビューエリア
    if (!editArea || !previewArea) return // テキストエリアとプレビューエリアがなかったらリターン

    // CSRFトークンを取得する関数
    const getCsrfToken = () => {
        const metaElem = document.querySelector("meta[name='csrf-token']");
        if (!metaElem) throw new Error("meta[name='csrf-token'] is not found.");

        const csrfToken = metaElem.content;
        if (!csrfToken) throw new Error("CSRF token is not set.");

        return csrfToken;
    };

    // POST リクエストして、マークダウンした形のHTMLを取得する
    const preview = async () => {
        try {
            const content = editArea.value;
            const token = getCsrfToken();

            const response = await fetch('/api/v1/activities/preview', {
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': token
                },
                method: 'POST',
                body: JSON.stringify({content})
            });

            if (!response.ok) throw new Error('Failed to fetch preview');

            const data = await response.json();
            previewArea.innerHTML = data.content;
            //console.log('Updated preview');
        } catch (error) {
            //console.warn('Error occurred while updating preview:', error);
        }
    };

    // 遅延ファンクションの定義
    const delay = (callback, ms = 0) => {
        let timer;
        return (...args) => {
            clearTimeout(timer);
            timer = setTimeout(() => callback(...args), ms);
        };
    };

    // タイピングが0.5秒停止したらプレビューする、タイピングし続ける時はプレビューしない。
    editArea.addEventListener('keyup', delay(preview, 500));
});

// コードのコピー機能
const copy = async (e) => {
    try {
        const code = e.closest('.highlight-wrap')?.querySelector('.rouge-code');
        if (!code) throw new Error("Code block not found.");

        await navigator.clipboard.writeText(code.innerText);

        const originalText = e.innerText;
        e.innerText = 'Copied!';

        setTimeout(() => (e.innerText = originalText), 2500);
    } catch (error) {
        console.warn("Failed to copy:", error);
    }
};
// ボタンにイベントリスナーを設定
document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".copy-btn").forEach((button) =>
        button.addEventListener("click", (event) => copy(event.target))
    );
});

// 画像のドラッグ&ドロップ保存機能
window.addEventListener('turbo:load', () => {
    const dragDropArea = document.getElementById('article_markdown_content')
    if (!dragDropArea) return

    // CSRFトークンを取得する関数
    const getCsrfToken = () => {
        const metaElem = document.querySelector("meta[name='csrf-token']");
        if (!metaElem) throw new Error("meta[name='csrf-token'] is not found.");

        const csrfToken = metaElem.content;
        if (!csrfToken) throw new Error("CSRF token is not set.");

        return csrfToken;
    };

    // カーソル位置に保存された画像のURLを挿入する関数
    const insertAtCursor = (dragDropArea, text) => {
        const startPos = dragDropArea.selectionStart;
        const endPos = dragDropArea.selectionEnd;
        const beforeText = dragDropArea.value.substring(0, startPos);
        const afterText = dragDropArea.value.substring(endPos, dragDropArea.value.length);

        dragDropArea.value = beforeText + text + afterText;
        dragDropArea.selectionStart = dragDropArea.selectionEnd = startPos + text.length;
    };

    dragDropArea.addEventListener("dragover", (event) => {
        event.preventDefault();
        dragDropArea.style.background = "#444444";
    });
    dragDropArea.addEventListener("dragleave", () => {
        dragDropArea.style.background = "white";
    });

    dragDropArea.addEventListener("drop", async (event) => {
        event.preventDefault();
        dragDropArea.style.background = "white";

        const file = event.dataTransfer.files[0];

        if (!file || !file.type.startsWith("image/")) {
            alert("画像ファイルのみアップロード可能です。");
            return;
        }
        const formData = new FormData();
        formData.append("image", file);
        try {
            const response = await fetch('/api/v1/activities/upload', {
                method: 'POST',
                body: formData,
                headers: {'X-CSRF-Token': getCsrfToken()},
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(`画像アップロードに失敗しました: ${errorData.message}`);
            }

            const data = await response.json();
            const imageUrl = data.url;

            // Markdown 形式で `dragDropArea` に画像を挿入
            const markdownImage = `\n![画像](${imageUrl})\n`;
            dragDropArea.focus();
            insertAtCursor(dragDropArea, markdownImage);

        } catch (error) {
            console.error("画像アップロードエラー:", error);
        }
    });
});















