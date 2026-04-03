(function () {
    var dialog = document.querySelector('[data-share-dialog]');
    var openButton = document.querySelector('[data-share-open]');

    if (!dialog || !openButton || typeof dialog.showModal !== 'function') {
        return;
    }

    openButton.addEventListener('click', function () {
        dialog.showModal();
    });

    dialog.addEventListener('click', function (event) {
        var rect = dialog.getBoundingClientRect();
        var inside = rect.top <= event.clientY && event.clientY <= rect.bottom
            && rect.left <= event.clientX && event.clientX <= rect.right;
        if (!inside) {
            dialog.close();
        }
    });
})();
