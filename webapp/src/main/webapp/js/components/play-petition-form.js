(function () {
    var form = document.querySelector('[data-play-petition-form]');
    if (!form) {
        return;
    }

    var contextPath = form.getAttribute('data-context-path') || '';
    var imageInput = form.querySelector('#coverImage');
    var sizeError = form.querySelector('[data-cover-image-size-error]');
    var addDateButton = form.querySelector('[data-add-date-button]');
    var additionalDatesContainer = form.querySelector('[data-additional-dates]');
    var titleInput = form.querySelector('[data-title-autocomplete]');
    var autocompleteResults = form.querySelector('[data-autocomplete-results]');
    var autocompleteUrl = form.getAttribute('data-autocomplete-url');
    var prefillUrlBase = form.getAttribute('data-prefill-url-base');
    var sourceObraIdInput = form.querySelector('[data-source-obra-id]');
    var sourceProductionIdInput = form.querySelector('[data-source-production-id]');
    var existingCoverImageIdInput = form.querySelector('[data-existing-cover-image-id]');
    var sourceSummary = form.querySelector('[data-source-summary]');
    var clearSourceButton = form.querySelector('[data-clear-source-button]');
    var coverPreviewContainer = form.querySelector('[data-cover-preview-container]');
    var coverPreviewImage = form.querySelector('[data-cover-preview-image]');
    var applyingPrefill = false;
    var autocompleteTimer = null;

    function setFieldValue(selector, value) {
        var field = form.querySelector(selector);
        if (field) {
            field.value = value || '';
        }
    }

    function setCheckboxes(ids) {
        var selected = {};
        if (ids && ids.length) {
            ids.forEach(function (id) {
                selected[String(id)] = true;
            });
        }
        var checkboxes = form.querySelectorAll('[data-genre-id]');
        Array.prototype.forEach.call(checkboxes, function (checkbox) {
            checkbox.checked = !!selected[checkbox.getAttribute('data-genre-id')];
        });
    }

    function syncSourceSummary() {
        if (!sourceSummary || !sourceObraIdInput) {
            return;
        }
        var hasSource = !!sourceObraIdInput.value;
        sourceSummary.classList.toggle('petition-form-error-hidden', !hasSource);
    }

    function toAssetUrl(relativeUrl) {
        if (!relativeUrl) {
            return '';
        }
        if (relativeUrl.indexOf('http://') === 0 || relativeUrl.indexOf('https://') === 0) {
            return relativeUrl;
        }
        if (contextPath && relativeUrl.indexOf(contextPath + '/') === 0) {
            return relativeUrl;
        }
        return contextPath + relativeUrl;
    }

    function syncCoverPreview(imageUrl) {
        if (!coverPreviewContainer || !coverPreviewImage || !existingCoverImageIdInput) {
            return;
        }
        var hasImage = !!existingCoverImageIdInput.value && !!imageUrl;
        coverPreviewContainer.classList.toggle('petition-form-error-hidden', !hasImage);
        if (hasImage) {
            coverPreviewImage.src = toAssetUrl(imageUrl);
        } else {
            coverPreviewImage.removeAttribute('src');
        }
    }

    function ensureAdditionalDateInputs(values) {
        if (!additionalDatesContainer) {
            return;
        }

        additionalDatesContainer.innerHTML = '';
        var dates = values && values.length ? values : [''];
        dates.forEach(function (value) {
            var input = document.createElement('input');
            input.type = 'date';
            input.name = 'additionalShowDates';
            input.value = value || '';
            input.className = 'petition-form-extra-date-input';
            additionalDatesContainer.appendChild(input);
        });
    }

    function syncErrorState() {
        if (!imageInput || !sizeError) {
            return false;
        }
        var maxBytes = parseInt(imageInput.getAttribute('data-max-bytes'), 10);
        var oversized = imageInput.files && imageInput.files.length > 0 && imageInput.files[0].size > maxBytes;
        sizeError.classList.toggle('petition-form-error-hidden', !oversized);
        imageInput.classList.toggle('petition-form-input-error', oversized);
        return oversized;
    }

    function hideAutocomplete() {
        if (autocompleteResults) {
            autocompleteResults.innerHTML = '';
            autocompleteResults.classList.add('petition-form-error-hidden');
        }
    }

    function renderAutocomplete(items) {
        if (!autocompleteResults) {
            return;
        }
        autocompleteResults.innerHTML = '';
        if (!items || !items.length) {
            hideAutocomplete();
            return;
        }

        items.forEach(function (item) {
            var button = document.createElement('button');
            button.type = 'button';
            button.className = 'petition-form-autocomplete-item';
            button.setAttribute('data-obra-id', item.obraId);
            button.innerHTML = '<strong>' + item.title + '</strong>' +
                (item.theater ? '<span>' + item.theater + '</span>' : '');
            button.addEventListener('click', function () {
                fetchPrefill(item.obraId);
            });
            autocompleteResults.appendChild(button);
        });

        autocompleteResults.classList.remove('petition-form-error-hidden');
    }

    function fetchSuggestions(query) {
        if (!autocompleteUrl || query.length < 2) {
            hideAutocomplete();
            return;
        }

        window.fetch(autocompleteUrl + '?q=' + encodeURIComponent(query), {
            headers: {
                Accept: 'application/json'
            }
        })
            .then(function (response) {
                if (!response.ok) {
                    return [];
                }
                return response.json();
            })
            .then(renderAutocomplete)
            .catch(hideAutocomplete);
    }

    function clearSourceSelection() {
        if (sourceObraIdInput) {
            sourceObraIdInput.value = '';
        }
        if (sourceProductionIdInput) {
            sourceProductionIdInput.value = '';
        }
        syncSourceSummary();
    }

    function fetchPrefill(obraId) {
        if (!prefillUrlBase) {
            return;
        }

        window.fetch(prefillUrlBase + encodeURIComponent(obraId), {
            headers: {
                Accept: 'application/json'
            }
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('prefill_failed');
                }
                return response.json();
            })
            .then(function (payload) {
                applyingPrefill = true;
                if (sourceObraIdInput) {
                    sourceObraIdInput.value = payload.obraId || '';
                }
                if (sourceProductionIdInput) {
                    sourceProductionIdInput.value = payload.productionId || '';
                }
                if (existingCoverImageIdInput) {
                    existingCoverImageIdInput.value = payload.coverImageId || '';
                }
                setFieldValue('#title', payload.title);
                setFieldValue('[data-prefill-synopsis]', payload.synopsis);
                setFieldValue('[data-prefill-duration]', payload.durationMinutes);
                setFieldValue('[data-prefill-language]', payload.language);
                setCheckboxes(payload.genreIds || []);
                var prefillCoverImageUrl = payload.coverImageUrl;
                if (!prefillCoverImageUrl && payload.coverImageId) {
                    prefillCoverImageUrl = '/images/' + payload.coverImageId;
                }
                if (imageInput) {
                    imageInput.value = '';
                }
                syncSourceSummary();
                syncCoverPreview(prefillCoverImageUrl);
                hideAutocomplete();
            })
            .finally(function () {
                window.setTimeout(function () {
                    applyingPrefill = false;
                }, 0);
            });
    }

    if (imageInput) {
        imageInput.addEventListener('change', function () {
            syncErrorState();
        });
    }

    if (addDateButton && additionalDatesContainer) {
        addDateButton.addEventListener('click', function () {
            var input = document.createElement('input');
            input.type = 'date';
            input.name = 'additionalShowDates';
            input.className = 'petition-form-extra-date-input';
            additionalDatesContainer.appendChild(input);
            input.focus();
        });
    }

    if (titleInput) {
        titleInput.addEventListener('input', function () {
            if (!applyingPrefill && sourceObraIdInput && sourceObraIdInput.value) {
                clearSourceSelection();
            }
            clearTimeout(autocompleteTimer);
            autocompleteTimer = window.setTimeout(function () {
                fetchSuggestions(titleInput.value.trim());
            }, 180);
        });

        titleInput.addEventListener('blur', function () {
            window.setTimeout(hideAutocomplete, 120);
        });
    }

    if (clearSourceButton) {
        clearSourceButton.addEventListener('click', function () {
            clearSourceSelection();
        });
    }

    form.addEventListener('submit', function (event) {
        if (syncErrorState()) {
            event.preventDefault();
        }
    });

    syncSourceSummary();
    syncCoverPreview(coverPreviewImage && coverPreviewImage.getAttribute('src') ? coverPreviewImage.getAttribute('src') : null);
})();
