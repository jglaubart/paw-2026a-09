(function () {
    var disabledTicketButtons = document.querySelectorAll('[data-ticket-status-message]');
    var ticketFeedbackWrap = document.querySelector('[data-ticket-feedback]');
    var ticketFeedbackText = document.querySelector('[data-ticket-feedback-text]');
    if (ticketFeedbackWrap && ticketFeedbackText && disabledTicketButtons.length) {
        Array.prototype.slice.call(disabledTicketButtons).forEach(function (button) {
            button.addEventListener('click', function () {
                ticketFeedbackText.textContent = button.getAttribute('data-ticket-status-message');
                ticketFeedbackWrap.classList.remove('obra-action-feedback-wrap-hidden');
            });
        });
    }

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
