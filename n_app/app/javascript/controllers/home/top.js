import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    adjustImageSize(event) {
        const img = event.target;
        const imgW = img.width;
        const imgH = img.height;
        const n_imgW = img.naturalWidth;
        const n_imgH = img.naturalHeight;
        
        if (Math.abs(n_imgW - n_imgH) > 90) {
            if (n_imgW > n_imgH) {
                img.style.width = "100%";
                img.style.height = "auto";
            } else if (n_imgW < n_imgH) {
                img.style.width = "auto";
                img.style.height = "100%";
            }
        }
        console.log(`横：${n_imgW}, 縦：${n_imgH}`)
    }
}