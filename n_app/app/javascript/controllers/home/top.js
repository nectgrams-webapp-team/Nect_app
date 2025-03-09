import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    adjustImageSize(event) {
        const img = event.target;
        const imgW = img.naturalWidth;
        const imgH = img.naturalHeight;
        if (imgW > imgH) {
            img.style.width = "230px";
            img.style.height = "auto";
        }
    }
}