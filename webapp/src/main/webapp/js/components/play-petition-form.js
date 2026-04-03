(function () {
    var form = document.querySelector('[data-play-petition-form]');
    if (!form) {
        return;
    }

    var imageInput = form.querySelector('#coverImage');
    var sizeError = form.querySelector('[data-cover-image-size-error]');
    if (!imageInput || !sizeError) {
        return;
    }

    var maxBytes = parseInt(imageInput.getAttribute('data-max-bytes'), 10);

    function hasOversizedFile() {
        return imageInput.files && imageInput.files.length > 0 && imageInput.files[0].size > maxBytes;
    }

    function syncErrorState() {
        var oversized = hasOversizedFile();
        sizeError.classList.toggle('petition-form-error-hidden', !oversized);
        imageInput.classList.toggle('petition-form-input-error', oversized);
        return oversized;
    }

    imageInput.addEventListener('change', syncErrorState);
    form.addEventListener('submit', function (event) {
        if (syncErrorState()) {
            event.preventDefault();
        }
    });
})();
