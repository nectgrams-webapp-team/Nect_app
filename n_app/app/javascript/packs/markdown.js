// プレビュー機能
window.addEventListener('turbo:load', () => {
    let editArea = document.getElementById('article_markdown_content') // テキストエリア
    let previewArea = document.getElementById('preview') // プレビューエリア
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
