(function () {
    var forms = document.querySelectorAll("[data-navbar-search]");
    var filterNames = ["genre", "theater", "dateFrom", "dateTo", "available"];

    if (!forms.length) {
        return;
    }

    function toArray(nodeList) {
        return Array.prototype.slice.call(nodeList || []);
    }

    function getDetails(form) {
        return form.querySelector("[data-search-popover]");
    }

    function getTrigger(form) {
        return form.querySelector("[data-search-trigger]");
    }

    function isPopoverOpen(form) {
        var details = getDetails(form);
        return !!(details && details.classList.contains("search-form-details-open"));
    }

    function getFieldLabel(form, fieldId, fallback) {
        var label = form.querySelector('label[for="' + fieldId + '"]');
        if (!label) {
            return fallback;
        }

        return label.textContent.replace(/\s+/g, " ").replace(/^\s+|\s+$/g, "");
    }

    function formatDate(value) {
        var parts;

        if (!value) {
            return "";
        }

        parts = value.split("-");

        if (parts.length !== 3) {
            return value;
        }

        return parts[2] + "/" + parts[1] + "/" + parts[0];
    }

    function getFilterState(form) {
        var state = [];
        var genre = form.querySelector('[name="genre"]');
        var theater = form.querySelector('[name="theater"]');
        var dateFrom = form.querySelector('[name="dateFrom"]');
        var dateTo = form.querySelector('[name="dateTo"]');
        var available = form.querySelector('[name="available"]');
        var availableLabel = form.querySelector(".search-form-check-title");

        if (genre && genre.value) {
            state.push({
                label: getFieldLabel(form, "navbar-search-genre", "Genero"),
                value: genre.options[genre.selectedIndex] ? genre.options[genre.selectedIndex].text : genre.value
            });
        }

        if (theater && theater.value) {
            state.push({
                label: getFieldLabel(form, "navbar-search-theater", "Sala"),
                value: theater.options[theater.selectedIndex] ? theater.options[theater.selectedIndex].text : theater.value
            });
        }

        if (dateFrom && dateFrom.value) {
            state.push({
                label: getFieldLabel(form, "navbar-search-date-from", "Desde"),
                value: formatDate(dateFrom.value)
            });
        }

        if (dateTo && dateTo.value) {
            state.push({
                label: getFieldLabel(form, "navbar-search-date-to", "Hasta"),
                value: formatDate(dateTo.value)
            });
        }

        if (available && available.checked) {
            state.push({
                label: "",
                value: availableLabel ? availableLabel.textContent.replace(/\s+/g, " ").replace(/^\s+|\s+$/g, "") : "Solo disponibles"
            });
        }

        return state;
    }

    function updatePanelOffset(form) {
        var shell = form.querySelector(".search-form-shell");
        var rect;
        var top;

        if (!shell) {
            return;
        }

        rect = shell.getBoundingClientRect();
        top = Math.max(rect.bottom + 16, 96);
        form.style.setProperty("--navbar-search-panel-top", top + "px");
    }

    function updateTriggerState(form) {
        var details = getDetails(form);
        var trigger = getTrigger(form);
        var clearButton = form.querySelector("[data-search-clear-filters]");
        var count = getFilterState(form).length;
        var countNodes = form.querySelectorAll("[data-search-filter-count]");

        if (count > 0) {
            form.classList.add("search-form-has-active-filters");
        } else {
            form.classList.remove("search-form-has-active-filters");
        }

        if (details) {
            if (count > 0) {
                details.classList.add("search-form-details-active");
            } else {
                details.classList.remove("search-form-details-active");
            }
        }

        if (trigger) {
            trigger.setAttribute("aria-expanded", isPopoverOpen(form) ? "true" : "false");
        }

        if (clearButton) {
            clearButton.disabled = count === 0;
            clearButton.setAttribute("aria-disabled", count === 0 ? "true" : "false");
        }

        toArray(countNodes).forEach(function (node) {
            node.textContent = count;

            if (count === 0) {
                node.classList.add("is-empty");
            } else {
                node.classList.remove("is-empty");
            }
        });
    }

    function renderChips(form) {
        var state = getFilterState(form);
        var chipList = form.querySelector("[data-search-chip-list]");
        var emptyState = form.querySelector("[data-search-empty-state]");

        if (!chipList || !emptyState) {
            updateTriggerState(form);
            return;
        }

        chipList.innerHTML = "";

        state.forEach(function (item) {
            var chip = document.createElement("span");
            chip.className = "search-form-chip";
            chip.textContent = item.label ? item.label + ": " + item.value : item.value;
            chipList.appendChild(chip);
        });

        emptyState.hidden = state.length > 0;
        updateTriggerState(form);
    }

    function setPopoverState(form, nextState, restoreFocus) {
        var details = getDetails(form);
        var focusTarget;

        if (!details) {
            return;
        }

        if (nextState) {
            details.classList.add("search-form-details-open");
            updatePanelOffset(form);
            focusTarget = form.querySelector('[name="genre"]') || form.querySelector('[name="theater"]');

            if (focusTarget) {
                window.setTimeout(function () {
                    if (isPopoverOpen(form)) {
                        focusTarget.focus();
                    }
                }, 40);
            }
        } else {
            details.classList.remove("search-form-details-open");
        }

        updateTriggerState(form);
        syncScrollLock();

        if (!nextState && restoreFocus) {
            window.setTimeout(function () {
                var trigger = getTrigger(form);

                if (trigger) {
                    trigger.focus();
                }
            }, 0);
        }
    }

    function closePopover(form, restoreFocus) {
        if (!isPopoverOpen(form)) {
            return;
        }

        setPopoverState(form, false, restoreFocus);
    }

    function syncScrollLock() {
        var hasOpenPopover = toArray(forms).some(function (form) {
            return isPopoverOpen(form);
        });

        if (window.matchMedia("(max-width: 1024px)").matches && hasOpenPopover) {
            document.body.classList.add("navbar-search-lock-scroll");
        } else {
            document.body.classList.remove("navbar-search-lock-scroll");
        }
    }

    function clearFilters(form) {
        filterNames.forEach(function (name) {
            var field = form.querySelector('[name="' + name + '"]');

            if (!field) {
                return;
            }

            if (field.type === "checkbox") {
                field.checked = false;
                return;
            }

            field.value = "";
        });

        renderChips(form);
    }

    function bindForm(form) {
        var fields = filterNames
            .map(function (name) {
                return form.querySelector('[name="' + name + '"]');
            })
            .filter(function (field) {
                return !!field;
            });
        var trigger = getTrigger(form);
        var closeNodes = form.querySelectorAll("[data-search-close]");
        var clearButton = form.querySelector("[data-search-clear-filters]");

        updatePanelOffset(form);
        renderChips(form);

        if (trigger) {
            trigger.addEventListener("click", function (event) {
                event.preventDefault();
                event.stopPropagation();
                setPopoverState(form, !isPopoverOpen(form), false);
            });
        }

        toArray(closeNodes).forEach(function (node) {
            node.addEventListener("click", function (event) {
                event.preventDefault();
                event.stopPropagation();
                closePopover(form, true);
            });
        });

        fields.forEach(function (field) {
            field.addEventListener("change", function () {
                renderChips(form);
            });

            if (field.type !== "checkbox") {
                field.addEventListener("input", function () {
                    renderChips(form);
                });
            }
        });

        if (clearButton) {
            clearButton.addEventListener("click", function (event) {
                event.preventDefault();
                clearFilters(form);
            });
        }
    }

    toArray(forms).forEach(bindForm);

    document.addEventListener("click", function (event) {
        toArray(forms).forEach(function (form) {
            if (!isPopoverOpen(form)) {
                return;
            }

            if (!form.contains(event.target)) {
                closePopover(form, false);
            }
        });
    });

    document.addEventListener("keydown", function (event) {
        if (event.key !== "Escape") {
            return;
        }

        toArray(forms).forEach(function (form) {
            closePopover(form, true);
        });
    });

    window.addEventListener("resize", function () {
        toArray(forms).forEach(updatePanelOffset);
        syncScrollLock();
    });

    window.addEventListener("scroll", function () {
        toArray(forms).forEach(function (form) {
            if (isPopoverOpen(form)) {
                updatePanelOffset(form);
            }
        });
    });
})();
