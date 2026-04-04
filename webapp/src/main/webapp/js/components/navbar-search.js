(function () {
    var forms = document.querySelectorAll("[data-navbar-search]");
    var filterNames = ["genre", "theater", "location", "dateFrom", "dateTo", "available"];

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

    function getFieldValue(field) {
        if (!field) {
            return "";
        }

        if (field.tagName === "SELECT") {
            return field.options[field.selectedIndex] ? field.options[field.selectedIndex].text : field.value;
        }

        return field.value;
    }

    function normalizeToken(value) {
        if (!value) {
            return "";
        }

        return value
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .replace(/\s+/g, " ")
            .replace(/^\s+|\s+$/g, "");
    }

    function getWordTokens(value) {
        var normalized = normalizeToken(value);

        if (!normalized) {
            return [];
        }

        return normalized.split(/[^a-z0-9]+/).filter(function (token) {
            return token.length > 0;
        });
    }

    function attachFilterComboboxes(form) {
        var comboboxes = toArray(form.querySelectorAll("[data-filter-combobox]"));

        comboboxes.forEach(function (combobox) {
            var input = combobox.querySelector("[data-filter-input]");
            var dropdown = combobox.querySelector("[data-filter-dropdown]");
            var optionButtons = toArray(combobox.querySelectorAll("[data-filter-option]"));
            var emptyState = combobox.querySelector("[data-filter-empty]");
            var activeIndex = -1;

            if (!input || !dropdown) {
                return;
            }

            function visibleOptions() {
                return optionButtons.filter(function (button) {
                    return !button.parentElement.hidden;
                });
            }

            function closeDropdown() {
                dropdown.hidden = true;
                input.setAttribute("aria-expanded", "false");
                activeIndex = -1;
                optionButtons.forEach(function (button) {
                    button.classList.remove("is-active");
                });
            }

            function openDropdown() {
                dropdown.hidden = false;
                input.setAttribute("aria-expanded", "true");
            }

            function applyActive(index) {
                var visible = visibleOptions();
                activeIndex = index;

                visible.forEach(function (button, buttonIndex) {
                    if (buttonIndex === activeIndex) {
                        button.classList.add("is-active");
                        button.scrollIntoView({ block: "nearest" });
                    } else {
                        button.classList.remove("is-active");
                    }
                });
            }

            function filterOptions() {
                var queryTokens = getWordTokens(input.value);
                var visibleCount = 0;

                optionButtons.forEach(function (button) {
                    var optionTokens = getWordTokens(button.getAttribute("data-filter-value"));
                    var matches = true;

                    if (queryTokens.length) {
                        matches = queryTokens.every(function (queryToken) {
                            return optionTokens.some(function (optionToken) {
                                return optionToken.indexOf(queryToken) === 0;
                            });
                        });
                    }

                    button.parentElement.hidden = !matches;

                    if (matches) {
                        visibleCount += 1;
                    }
                });

                if (emptyState) {
                    emptyState.hidden = visibleCount > 0;
                }

                activeIndex = -1;
                optionButtons.forEach(function (button) {
                    button.classList.remove("is-active");
                });
            }

            function selectOption(button) {
                input.value = button.getAttribute("data-filter-value") || "";
                renderChips(form);
                closeDropdown();
            }

            optionButtons.forEach(function (button) {
                button.addEventListener("click", function () {
                    selectOption(button);
                });
            });

            input.addEventListener("focus", function () {
                filterOptions();
                openDropdown();
            });

            input.addEventListener("click", function () {
                filterOptions();
                openDropdown();
            });

            input.addEventListener("input", function () {
                filterOptions();
                openDropdown();
                renderChips(form);
            });

            input.addEventListener("keydown", function (event) {
                var visible;

                if (event.key === "Escape") {
                    closeDropdown();
                    return;
                }

                visible = visibleOptions();

                if (!visible.length) {
                    return;
                }

                if (event.key === "ArrowDown") {
                    event.preventDefault();
                    if (dropdown.hidden) {
                        openDropdown();
                    }
                    applyActive((activeIndex + 1) % visible.length);
                    return;
                }

                if (event.key === "ArrowUp") {
                    event.preventDefault();
                    if (dropdown.hidden) {
                        openDropdown();
                    }
                    applyActive(activeIndex <= 0 ? visible.length - 1 : activeIndex - 1);
                    return;
                }

                if (event.key === "Enter" && !dropdown.hidden && activeIndex >= 0) {
                    event.preventDefault();
                    selectOption(visible[activeIndex]);
                }
            });

            document.addEventListener("click", function (event) {
                if (!combobox.contains(event.target)) {
                    closeDropdown();
                }
            });

            form.addEventListener("reset", function () {
                closeDropdown();
                if (emptyState) {
                    emptyState.hidden = true;
                }
                optionButtons.forEach(function (button) {
                    button.parentElement.hidden = false;
                    button.classList.remove("is-active");
                });
            });
        });
    }

    function getFilterState(form) {
        var state = [];
        var genre = form.querySelector('[name="genre"]');
        var theater = form.querySelector('[name="theater"]');
        var location = form.querySelector('[name="location"]');
        var dateFrom = form.querySelector('[name="dateFrom"]');
        var dateTo = form.querySelector('[name="dateTo"]');
        var available = form.querySelector('[name="available"]');
        var availableLabel = form.querySelector(".search-form-check-title");

        if (genre && genre.value) {
            state.push({
                label: getFieldLabel(form, "navbar-search-genre", "Genero"),
                value: getFieldValue(genre)
            });
        }

        if (theater && theater.value) {
            state.push({
                label: getFieldLabel(form, "navbar-search-theater", "Sala"),
                value: getFieldValue(theater)
            });
        }

        if (location && location.value) {
            state.push({
                label: getFieldLabel(form, "navbar-search-location", "Zona"),
                value: getFieldValue(location)
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
            focusTarget = form.querySelector('[name="genre"]') || form.querySelector('[name="theater"]') || form.querySelector('[name="location"]');

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

        attachFilterComboboxes(form);
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
