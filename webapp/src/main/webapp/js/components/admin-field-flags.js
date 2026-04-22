(function () {
    var form = document.querySelector('.adm-field-form');
    if (!form) return;

    function syncField(field) {
        var key = field.dataset.fieldKey;
        var checkbox = field.querySelector('.adm-hidden-check');
        var commentBox = field.querySelector('[data-flag-comment="' + key + '"]');
        var textarea = commentBox ? commentBox.querySelector('textarea') : null;
        var isFlagged = checkbox && checkbox.checked;

        field.classList.toggle('is-flagged', isFlagged);
        if (commentBox) commentBox.classList.toggle('adm-field-comment-hidden', !isFlagged);
        if (textarea) textarea.disabled = !isFlagged;
    }

    form.querySelectorAll('.adm-flag-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var field = btn.closest('.adm-field');
            var checkbox = field ? field.querySelector('.adm-hidden-check') : null;
            if (!checkbox) return;

            checkbox.checked = !checkbox.checked;
            syncField(field);
        });
    });

    form.querySelectorAll('.adm-field').forEach(function (field) {
        syncField(field);
    });
})();
