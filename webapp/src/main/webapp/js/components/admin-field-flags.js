(function () {
    var form = document.querySelector('.adm-field-form');
    if (!form) return;
    var rowToggleMode = form.classList.contains('adm-field-form-row-toggle');

    function isInteractiveTarget(target) {
        if (!target) {
            return false;
        }

        return !!target.closest('textarea, a, button, input, select, [contenteditable="true"], .adm-field-comment');
    }

    function getCheckbox(field) {
        return field ? field.querySelector('.adm-hidden-check') : null;
    }

    function isRowToggleable(field) {
        var checkbox = getCheckbox(field);

        if (!rowToggleMode || !checkbox) {
            return false;
        }

        return checkbox.name === 'issueFields';
    }

    function toggleField(field) {
        var checkbox = getCheckbox(field);

        if (!checkbox) {
            return;
        }

        checkbox.checked = !checkbox.checked;
        syncField(field);
    }

    function syncField(field) {
        var key = field.dataset.fieldKey;
        var checkbox = getCheckbox(field);
        var flagButton = field.querySelector('.adm-flag-btn');
        var commentBox = field.querySelector('[data-flag-comment="' + key + '"]');
        var textarea = commentBox ? commentBox.querySelector('textarea') : null;
        var isFlagged = checkbox && checkbox.checked;
        var rowToggleable = isRowToggleable(field);

        field.classList.toggle('is-flagged', isFlagged);
        if (commentBox) commentBox.classList.toggle('adm-field-comment-hidden', !isFlagged);
        if (textarea) textarea.disabled = !isFlagged;

        if (flagButton) {
            flagButton.setAttribute('aria-pressed', isFlagged ? 'true' : 'false');
        }

        if (rowToggleable) {
            field.classList.add('adm-field-toggleable');
            field.setAttribute('tabindex', '0');
            field.setAttribute('role', 'checkbox');
            field.setAttribute('aria-checked', isFlagged ? 'true' : 'false');
        }
    }

    form.querySelectorAll('.adm-flag-btn').forEach(function (btn) {
        btn.addEventListener('click', function (event) {
            var field = btn.closest('.adm-field');

            event.stopPropagation();
            toggleField(field);
        });
    });

    form.querySelectorAll('.adm-field').forEach(function (field) {
        syncField(field);

        if (!isRowToggleable(field)) {
            return;
        }

        field.addEventListener('click', function (event) {
            if (isInteractiveTarget(event.target)) {
                return;
            }

            toggleField(field);
        });

        field.addEventListener('keydown', function (event) {
            if (isInteractiveTarget(event.target) && event.target !== field) {
                return;
            }

            if (event.key !== 'Enter' && event.key !== ' ') {
                return;
            }

            event.preventDefault();
            toggleField(field);
        });
    });
})();
