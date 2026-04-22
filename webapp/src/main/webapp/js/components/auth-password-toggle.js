(function () {
    var toggleButtons = document.querySelectorAll("[data-password-toggle]");

    if (!toggleButtons.length) {
        return;
    }

    function resolveInput(button) {
        var inputId = button.getAttribute("aria-controls");

        if (inputId) {
            return document.getElementById(inputId);
        }

        return button.parentElement ? button.parentElement.querySelector("[data-password-input]") : null;
    }

    function resolveAriaLabel(button, state) {
        var label = state === "show" ? button.getAttribute("data-aria-show") : button.getAttribute("data-aria-hide");

        return label || "";
    }

    function updateButton(button, isVisible) {
        var ariaLabel = resolveAriaLabel(button, isVisible ? "hide" : "show");

        if (ariaLabel) {
            button.setAttribute("aria-label", ariaLabel);
        }

        button.setAttribute("aria-pressed", isVisible ? "true" : "false");
        button.classList.toggle("is-visible", isVisible);
    }

    toggleButtons.forEach(function (button) {
        var input = resolveInput(button);

        if (!input) {
            return;
        }

        updateButton(button, input.type === "text");

        button.addEventListener("click", function () {
            var isHidden = input.type === "password";

            input.type = isHidden ? "text" : "password";
            updateButton(button, isHidden);
        });
    });
})();
