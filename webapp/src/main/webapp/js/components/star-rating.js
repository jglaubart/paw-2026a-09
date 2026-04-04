(function () {
    var components = document.querySelectorAll("[data-star-rating]");

    if (!components.length) {
        return;
    }

    function toArray(nodeList) {
        return Array.prototype.slice.call(nodeList || []);
    }

    function matches(element, selector) {
        var matcher = element.matches || element.msMatchesSelector || element.webkitMatchesSelector;
        return matcher ? matcher.call(element, selector) : false;
    }

    function closest(element, selector) {
        var current = element;

        while (current && current.nodeType === 1) {
            if (matches(current, selector)) {
                return current;
            }
            current = current.parentElement;
        }

        return null;
    }

    function parseValue(value) {
        var parsed = parseFloat(value);
        return isNaN(parsed) ? 0 : parsed;
    }

    function getSelected(component) {
        return parseValue(component.getAttribute("data-selected"));
    }

    function getPreview(component) {
        return parseValue(component.getAttribute("data-preview"));
    }

    function getCurrent(component) {
        var preview = getPreview(component);
        return preview > 0 ? preview : getSelected(component);
    }

    function getMax(component) {
        return parseValue(component.getAttribute("data-max")) || 5;
    }

    function isAutoSubmit(component) {
        return component.getAttribute("data-autosubmit") === "true";
    }

    function syncHiddenInput(component, value) {
        var hiddenInput = component.querySelector("[data-star-rating-hidden-input]");

        if (!hiddenInput) {
            return;
        }

        hiddenInput.value = value > 0 ? String(value) : "";
    }

    function setSelected(component, value) {
        component.setAttribute("data-selected", value);
        syncHiddenInput(component, value);
    }

    function setPreview(component, value) {
        if (value > 0) {
            component.setAttribute("data-preview", value);
        } else {
            component.removeAttribute("data-preview");
        }
    }

    function setBusy(component, busy) {
        var buttons = toArray(component.querySelectorAll("[data-star-rating-star]"));

        if (busy) {
            component.classList.add("star-rating-loading");
        } else {
            component.classList.remove("star-rating-loading");
        }

        buttons.forEach(function (button) {
            button.disabled = busy;
        });
    }

    function updateCaption(component, message) {
        var caption = component.querySelector("[data-star-rating-caption]");
        var currentValue = getCurrent(component);
        var maxValue = getMax(component);
        var promptText = component.getAttribute("data-prompt-text") || "Sin calificar";

        if (!caption) {
            return;
        }

        if (message) {
            caption.textContent = message;
            return;
        }

        if (currentValue > 0) {
            caption.textContent = currentValue + "/" + maxValue;
        } else {
            caption.textContent = promptText;
        }
    }

    function updateButtons(component) {
        var currentValue = getCurrent(component);
        var selectedValue = getSelected(component);
        var previewValue = getPreview(component);
        var buttons = toArray(component.querySelectorAll("[data-star-rating-star]"));

        buttons.forEach(function (button) {
            var ratingValue = parseValue(button.getAttribute("data-rating-value"));
            var hasHalfValue = selectedValue < ratingValue && selectedValue + 0.5 >= ratingValue;

            button.classList.remove("star-rating-star-active");
            button.classList.remove("star-rating-star-preview");
            button.classList.remove("star-rating-star-half");

            if (previewValue > 0 && ratingValue <= previewValue) {
                button.classList.add("star-rating-star-preview");
            } else if (ratingValue <= selectedValue) {
                button.classList.add("star-rating-star-active");
            } else if (hasHalfValue) {
                button.classList.add("star-rating-star-half");
            }
        });

        updateCaption(component);
    }

    function unlockReviewGate(component) {
        var panel = closest(component, ".obra-interact-panel");
        var reviewForm;
        var reviewModule;
        var controls;
        var textarea;

        if (!panel) {
            return;
        }

        reviewForm = panel.querySelector("[data-review-gate]");
        reviewModule = panel.querySelector("[data-review-module]");

        if (!reviewForm) {
            return;
        }

        reviewForm.classList.remove("obra-review-form-locked");
        if (reviewModule) {
            reviewModule.classList.remove("obra-participation-review-locked");
        }
        controls = toArray(reviewForm.querySelectorAll("textarea, button"));
        controls.forEach(function (control) {
            control.disabled = false;
        });

        textarea = reviewForm.querySelector("textarea");
        if (textarea) {
            if (textarea.getAttribute("data-enabled-placeholder")) {
                textarea.setAttribute("placeholder", textarea.getAttribute("data-enabled-placeholder"));
            }
            textarea.focus();
        }
    }

    function submitRating(component, button) {
        var form = closest(button, "form");
        var previousSelected = getSelected(component);
        var buttonValue = parseValue(button.getAttribute("data-rating-value"));
        var nextValue = buttonValue;
        var successText = component.getAttribute("data-success-text") || "Guardada";
        var errorText = component.getAttribute("data-error-text") || "No se pudo guardar. Reintenta.";
        var requestBody;

        if (!form || typeof window.fetch !== "function" || !isAutoSubmit(component)) {
            return false;
        }

        if (typeof form.reportValidity === "function" && !form.reportValidity()) {
            return true;
        }

        setSelected(component, nextValue);
        setPreview(component, 0);
        updateButtons(component);
        setBusy(component, true);
        updateCaption(component, "Guardando");

        requestBody = new URLSearchParams(new FormData(form));
        requestBody.set(button.name, String(nextValue));

        window.fetch(form.action, {
            method: form.method || "POST",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: requestBody.toString()
        }).then(function (response) {
            if (!response.ok) {
                throw new Error("rating_save_failed");
            }

            setBusy(component, false);
            updateCaption(component, successText);
            unlockReviewGate(component);

            window.setTimeout(function () {
                updateCaption(component);
            }, 1800);
        }).catch(function () {
            setBusy(component, false);
            setSelected(component, previousSelected);
            setPreview(component, 0);
            updateButtons(component);
            updateCaption(component, errorText);

            window.setTimeout(function () {
                updateCaption(component);
            }, 2400);
        });

        return true;
    }

    function focusRelative(buttons, currentButton, direction) {
        var index = buttons.indexOf(currentButton);
        var nextIndex = index + direction;

        if (nextIndex < 0) {
            nextIndex = 0;
        }

        if (nextIndex >= buttons.length) {
            nextIndex = buttons.length - 1;
        }

        if (buttons[nextIndex]) {
            buttons[nextIndex].focus();
        }
    }

    function bindComponent(component) {
        var buttons = toArray(component.querySelectorAll("[data-star-rating-star]"));

        if (!buttons.length) {
            return;
        }

        syncHiddenInput(component, getSelected(component));
        updateButtons(component);

        buttons.forEach(function (button) {
            button.addEventListener("mouseenter", function () {
                setPreview(component, parseValue(button.getAttribute("data-rating-value")));
                updateButtons(component);
            });

            button.addEventListener("focus", function () {
                setPreview(component, parseValue(button.getAttribute("data-rating-value")));
                updateButtons(component);
            });

            button.addEventListener("blur", function () {
                window.setTimeout(function () {
                    if (!component.contains(document.activeElement)) {
                        setPreview(component, 0);
                        updateButtons(component);
                    }
                }, 0);
            });

            button.addEventListener("click", function (event) {
                if (submitRating(component, button)) {
                    event.preventDefault();
                    return;
                }

                if (isAutoSubmit(component)) {
                    return;
                }

                event.preventDefault();
                setSelected(component, parseValue(button.getAttribute("data-rating-value")));
                setPreview(component, 0);
                updateButtons(component);
            });

            button.addEventListener("keydown", function (event) {
                if (event.key === "ArrowRight" || event.key === "ArrowUp") {
                    event.preventDefault();
                    focusRelative(buttons, button, 1);
                } else if (event.key === "ArrowLeft" || event.key === "ArrowDown") {
                    event.preventDefault();
                    focusRelative(buttons, button, -1);
                } else if (event.key === "Home") {
                    event.preventDefault();
                    buttons[0].focus();
                } else if (event.key === "End") {
                    event.preventDefault();
                    buttons[buttons.length - 1].focus();
                }
            });
        });

        component.addEventListener("mouseleave", function () {
            setPreview(component, 0);
            updateButtons(component);
        });
    }

    toArray(components).forEach(bindComponent);
})();
