(function () {
    var reviewForm = document.querySelector('.petition-admin-decision-form');
    if (!reviewForm) {
        return;
    }

    function syncCommentVisibility(checkbox) {
        var key = checkbox.getAttribute('data-comment-key');
        if (!key) {
            return;
        }

        var container = reviewForm.querySelector('[data-review-comment="' + key + '"]');
        var textarea = reviewForm.querySelector('[data-review-comment-input="' + key + '"]');
        if (!container || !textarea) {
            return;
        }

        var isChecked = checkbox.checked;
        container.classList.toggle('petition-admin-review-comment-hidden', !isChecked);
        textarea.disabled = !isChecked;
    }

    var toggles = reviewForm.querySelectorAll('[data-review-issue-toggle="true"]');
    Array.prototype.forEach.call(toggles, function (toggle) {
        toggle.addEventListener('change', function () {
            syncCommentVisibility(toggle);
        });
        syncCommentVisibility(toggle);
    });
})();
